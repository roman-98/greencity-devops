module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"
  
  username               = module.rds.var.username
  password               = module.rds.var.password

  vpc_security_group_ids = module.vpc.rds_security_group_id
  subnet_group_name      = module.vpc.rds_subnet_group_name
  subnet_ids             = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]

}
