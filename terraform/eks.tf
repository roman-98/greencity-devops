module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = "GreenCity"
  cluster_version = 1.27
  subnet_ids      = [
    "10.0.2.0/24",
    "10.0.4.0/24",
  ]

  enable_irsa = true

  tags = {
    cluster = "greencity"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
    }
  }
}
