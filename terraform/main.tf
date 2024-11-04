module "vpc" {
  source         = "./modules/vpc"
  region         = var.region
  vpc_cidr_block = var.vpc_cidr_block
  cluster_name   = var.cluster_name
}

module "rds" {
  source            = "./modules/rds"
  name              = var.rds.name
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc_id
  allocated_storage = var.rds.allocated_storage
  engine            = var.rds.engine
  engine_version    = var.rds.engine_version
  instance_class    = var.rds.instance_class
  db_name           = var.rds.db_name
  username          = var.username  
  password          = var.password 

  depends_on = [module.vpc]
}

module "eks" {
  source             = "./modules/eks"
  vpc_id             = module.vpc.vpc_id
  cluster_sg_name    = "${var.cluster_name}-cluster-sg"
  nodes_sg_name      = "${var.cluster_name}-node-sg"
  node_group_name    = "${var.cluster_name}-node-group"
  private_subnet_ids = module.vpc.private_subnet_ids
  publc_subnet_ids   = module.vpc.publc_subnet_ids
  cluster_name       = var.cluster_name 
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
