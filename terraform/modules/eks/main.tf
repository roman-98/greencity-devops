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
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.main.endpoint
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
        Resource = "arn:aws:secretsmanager:eu-west-3:730335226605:secret:prod/greencity-secrets-v1-JCNLwZ"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "myapp_secrets_policy_attachment" {
  policy_arn = aws_iam_policy.myapp_secrets_policy.arn
  role       = aws_iam_role.myapp_secrets.name
}

resource "kubernetes_service_account" "myapp" {
  metadata {
    name      = "myapp"
    namespace = "prod"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.myapp_secrets.arn
    }
  }

  depends_on = [aws_eks_node_group.main]
}

data "aws_secretsmanager_secret_version" "myapp_secrets" {
  secret_id = "prod/greencity-secrets-v1"
}

output "secret_content" {
  value = jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string)
  sensitive = true

  depends_on = [aws_eks_node_group.main]
}

resource "kubernetes_secret" "myapp_k8s_secret" {
  metadata {
    name      = "myapp-k8s-secret"
    namespace = "prod"
  }

  data = {
    datasourceUrl                 = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DATASOURCE_URL", ""))
    datasourceUser                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DATASOURCE_USER", ""))
    datasourcePassword            = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DATASOURCE_PASSWORD", ""))
    emailAddress                  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EMAIL_ADDRESS", ""))
    emailPassword                 = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EMAIL_PASSWORD", ""))
    googleClientId                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_CLIENT_ID", ""))
    googleApiKey                  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_API_KEY", ""))
    googleClientIdManager         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_CLIENT_ID_MANAGER", ""))
    cloudName                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "CLOUD_NAME", ""))
    apiKey                        = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "API_KEY", ""))
    apiSecret                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "API_SECRET", ""))
    maxFileSize                   = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "MAX_FILE_SIZE", ""))
    maxRequestSize                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "MAX_REQUEST_SIZE", ""))
    bucketName                    = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "BUCKET_NAME", ""))
    staticUrl                     = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "STATIC_URL", ""))
    googleApplicationCredentials  = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "GOOGLE_APPLICATION_CREDENTIALS", ""))
    defaultProfilePicture         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "DEFAULT_PROFILE_PICTURE", ""))
    azureConnectionString         = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "AZURE_CONNECTION_STRING", ""))
    azureContainerName            = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "AZURE_CONTAINER_NAME", ""))
    endpointSuffix                = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "EndpointSuffix", ""))
    chatLink                      = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "CHAT_LINK", ""))
    profile                       = base64encode(lookup(jsondecode(data.aws_secretsmanager_secret_version.myapp_secrets.secret_string), "PROFILE", ""))
  }

  depends_on = [aws_eks_node_group.main]
}