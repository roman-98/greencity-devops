provider "aws" {
  region = var.region
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn 

  vpc_config {
    subnet_ids              = var.public_subnets_ids
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  version = var.kubernetes_version

  tags = {
    Name        = var.cluster_name
    Environment = var.env
  }

  depends_on = [aws_vpc.vpc] 
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn 

  subnet_ids = var.public_subnets_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  tags = {
    Name        = "${var.cluster_name}-node-group"
    Environment = var.env
  }

  depends_on = [aws_eks_cluster.eks]
}
