module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"

  username             = var.username  
  password             = var.password 

  vpc_security_group_ids = module.vpc.rds_security_group_id
  subnet_group_name      = module.vpc.rds_subnet_group_name
  subnet_ids             = module.vpc.private_subnet_a_id

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
