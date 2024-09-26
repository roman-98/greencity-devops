module "vpc" {
  source = "./modules/vpc"
}

module "rds" {
  source = "./modules/rds"

  identifier             = "my-database"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "postgres"
  password               = "yourpassword"
  db_name                = "mydb"

  vpc_security_group_ids = [module.vpc.rds_security_group_id]
  subnet_group_name      = module.vpc.rds_subnet_group_name
  subnet_ids             = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]

}
