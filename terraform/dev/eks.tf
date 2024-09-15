module "eks" {
  source = "../modules/eks"

  region               = "eu-west-3"
  env                  = "dev"
  cluster_name         = "dev-cluster"
  vpc_id               = module.vpc.vpc_id  
  public_subnets_ids   = module.vpc.public_subnets_ids
  eks_role_arn         = "arn:aws:iam::123456789012:role/EKSClusterRole"  
  node_role_arn        = "arn:aws:iam::123456789012:role/EKSNodeRole"     
  desired_size         = 2
  max_size             = 3
  min_size             = 1
  instance_type        = "t3.medium"
  ssh_key_name         = "my-ssh-key"
  kubernetes_version   = "1.21"
}
