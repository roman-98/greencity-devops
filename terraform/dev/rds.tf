module "rds" {
  source = "../modules/rds"

  region               = "eu-west-3"
  env                  = "dev"
  vpc_id               = module.vpc.vpc_id  
  private_subnets_ids  = module.vpc.private_subnets_ids
  db_identifier        = "dev-db"
  db_name              = "devdb"
  db_engine            = "postgres"
  db_instance_class    = "db.t3.micro"
  allocated_storage    = 20
  db_username          = "admin"
  db_password          = "supersecretpassword" 
  db_port              = 5432
  allowed_cidr_blocks  = ["10.0.0.0/16"] 

  multi_az             = false
  storage_encrypted    = true
  skip_final_snapshot  = true
}
