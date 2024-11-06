module "vpc" {
  source         = "./modules/vpc"
  cluster_name   = "main"
}

module "rds" {
  source            = "./modules/rds"
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc_id
  username          = var.username  
  password          = var.password 
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  cluster_sg_name    = "main-cluster-sg"
  nodes_sg_name      = "main-node-sg"
  node_group_name    = "main-node-group"
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids 
  cluster_name       = "main" 
}

variable "username" {
  description = "The master username for the DB instance."
  type        = string
  sensitive   = true
}

variable "password" {
  description = "The master password for the DB instance."
  type        = string
  sensitive   = true
}
