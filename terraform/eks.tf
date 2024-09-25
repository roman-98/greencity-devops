resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.public_subnet_a.id,
      aws_subnet.public_subnet_b.id
    ]
    endpoint_public_access  = true
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy]

  # Зв'язування з роллю VPC CNI
  kubernetes_network_config {
    service_ipv4_cidr = "172.20.0.0/16"
  }
}

resource "aws_iam_role" "eks_role" {
  name = "eks_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = [
            "ec2.amazonaws.com",
            "eks.amazonaws.com"
      ]}
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}

# IAM роль для EKS воркерів
resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Federated = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
      }
      Condition = {
        StringEquals = {
          "${module.eks.oidc_provider_arn}:sub" = "system:serviceaccount:kube-system:aws-node"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_eks_cluster_oidc_provider" "eks_oidc" {
  cluster_name = aws_eks_cluster.my_cluster.name
}

# Модуль для IAM ролі для VPC CNI (aws-node)
module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 4.12"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer,
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  depends_on = [aws_eks_cluster.my_cluster]
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_eks_cluster.my_cluster]
}

resource "kubectl_manifest" "aws_auth" {
  manifest = {
    apiVersion = "v1"
    kind      = "ConfigMap"
    metadata = {
      name      = "aws-auth"
      namespace = "kube-system"
    }
    data = {
      mapRoles = yamlencode([
        {
          rolearn = aws_iam_role.eks_node_role.arn
          username = "system:node:{{EC2PrivateDNSName}}"
          groups = ["system:bootstrappers", "system:nodes"]
        },
        {
          rolearn = aws_iam_role.eks_role.arn
          username = "admin"
          groups = ["system:masters"]
        }
      ])
    }
  }
  
  depends_on = [aws_eks_cluster.my_cluster]
}

resource "kubectl_manifest" "database_secret" {
  manifest = {
    apiVersion = "v1"
    kind      = "Secret"
    metadata = {
      name      = "db-secret"
      namespace = "default"  # Змініть на ваш неймспейс
    }
    type = "Opaque"
    data = {
      username = base64encode("your-db-username")  # Змініть на ваше ім'я користувача
      password = base64encode("your-db-password")  # Змініть на ваш пароль
    }
  }

  depends_on = [kubectl_manifest.aws_auth]
}
