module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  
  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = var.private_subnets

  enable_irsa = true

  tags = {
    Name = var.cluster_name
  }

  vpc_id = var.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = var.vpc_security_group_ids  # Тут ми використовуємо vpc_security_group_ids
  }

  eks_managed_node_groups = {
    node_group = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }
}
