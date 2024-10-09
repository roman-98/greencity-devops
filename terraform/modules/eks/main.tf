resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids              = [var.private_subnet_a_id, var.private_subnet_b_id]
    security_group_ids      = [var.eks_security_group_id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = [var.private_subnet_a_id, var.private_subnet_b_id]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [aws_iam_role_policy_attachment.eks_nodes_policy]
}

resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "eks_nodes" {
  name = "${var.cluster_name}-eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_nodes_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_nodes_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.name
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_id" {
  value       = aws_eks_cluster.main.id
}

data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "myapp_secrets" {
  name = "${aws_eks_cluster.main.name}-myapp-secrets"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated: aws_iam_openid_connect_provider.eks.id
        },
        Action: "sts:AssumeRoleWithWebIdentity",
        Condition: {
          StringEquals: {
            "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub": "system:serviceaccount:prod:myapp"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "myapp_secrets_policy" {
  name = "${aws_eks_cluster.main.name}-myapp-secrets-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "myapp_secrets_policy_attachment" {
  policy_arn = aws_iam_policy.myapp_secrets_policy.arn
  role       = aws_iam_role.myapp_secrets.name
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}

resource "kubernetes_service_account" "myapp" {
  metadata {
    name      = "myapp"
    namespace = "prod"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.myapp_secrets.arn
    }
  }

  depends_on = [kubernetes_namespace.prod]
}

data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "prod/greencity-secrets-v1"
}

data "aws_secretsmanager_secret_version" "myapp_secrets" {
  secret_id = "prod/greencity-secrets-v2"
}

locals {
  myapp_secrets  = jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string)
  db_secret      = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)
}

output "secret_content" {
  value = {
    myapp_secrets = local.myapp_secrets
    db_secret     = local.db_secret
  }
  sensitive = true

  depends_on = [aws_eks_node_group.main]
}

resource "kubernetes_secret" "myapp_k8s_secret" {
  metadata {
    name      = "myapp-k8s-secret"
    namespace = "prod"
  }

  data = {
    DATASOURCE_URL                 = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string), "DATASOURCE_URL"))
    DATASOURCE_USER                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DATASOURCE_USER"))
    DATASOURCE_PASSWORD            = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DATASOURCE_PASSWORD"))
    EMAIL_ADDRESS                  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EMAIL_ADDRESS"))
    EMAIL_PASSWORD                 = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EMAIL_PASSWORD"))
    GOOGLE_CLIENT_ID                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_CLIENT_ID"))
    GOOGLE_API_KEY                  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_API_KEY"))
    GOOGLE_CLIENT_ID_MANAGER         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_CLIENT_ID_MANAGER"))
    CLOUD_NAME                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "CLOUD_NAME"))
    API_KEY                        = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "API_KEY"))
    API_SECRET                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "API_SECRET"))
    MAX_FILE_SIZE                   = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "MAX_FILE_SIZE"))
    MAX_REQUEST_SIZE                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "MAX_REQUEST_SIZE"))
    BUCKET_NAME                    = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "BUCKET_NAME"))
    STATIC_URL                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "STATIC_URL"))
    GOOGLE_APPLICATION_CREDENTIALS  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_APPLICATION_CREDENTIALS"))
    DEFAULT_PROFILE_PICTURE         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DEFAULT_PROFILE_PICTURE"))
    AZURE_CONNECTION_STRING         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "AZURE_CONNECTION_STRING"))
    AZURE_CONTAINER_NAME            = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "AZURE_CONTAINER_NAME"))
    EndpointSuffix                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EndpointSuffix"))
    CHAT_LINK                      = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "CHAT_LINK"))
    PROFILE                       = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "PROFILE"))
  }

  depends_on = [kubernetes_namespace.prod]
}