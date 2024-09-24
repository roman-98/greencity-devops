# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = module.vpc.cidr_block
  azs        = ["us-west-2a", "us-west-2b"]
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# EKS Module
module "eks" {
  source = "./modules/eks"
  
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  cluster_name     = "my-eks-cluster"
  instance_type    = "t3.medium"
  cluster_role_arn = aws_iam_role.eks_cluster_role.arn
  node_role_arn    = aws_iam_role.eks_node_role.arn
}

# RDS Module
module "rds" {
  source = "./modules/rds"
  
  vpc_id            = module.vpc.vpc_id
  db_identifier     = "my-db"
  db_instance_class = "db.t3.medium"
  db_name           = "mydatabase"
  db_user           = "admin"
  db_password       = "password123"
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
