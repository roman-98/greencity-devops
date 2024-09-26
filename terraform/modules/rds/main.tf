module "vpc" {
  source = "../vpc"
}

resource "aws_db_instance" "greencity" {
  identifier              = var.identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  username                = var.username
  password                = var.password
  db_name                 = var.db_name
  vpc_security_group_ids  = module.vpc.rds_security_group_id
  db_subnet_group_name    = module.vpc.rds_subnet_group_name
  skip_final_snapshot     = var.skip_final_snapshot

  tags = var.tags
}
