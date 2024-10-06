module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"

  username             = var.username  
  password             = var.password 

  vpc_security_group_ids = [module.vpc.rds_security_group_id]
  subnet_group_name      = module.vpc.rds_subnet_group_name
  subnet_ids             = [
    module.vpc.private_subnet_a_id,
    module.vpc.private_subnet_b_id
  ]

  depends_on = [module.vpc]
}

module "eks" {
  source = "./modules/eks"

  private_subnet_a_id   = module.vpc.private_subnet_a_id
  private_subnet_b_id   = module.vpc.private_subnet_b_id
  eks_security_group_id = module.vpc.eks_security_group_id
}

variable "username" {
  description = "The master username for the DB instance."
  type        = string
}

variable "password" {
  description = "The master password for the DB instance."
  type        = string
  sensitive   = true
}
