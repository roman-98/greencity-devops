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
  multi_az                = var.multi_az

  tags = var.tags
}

resource "aws_db_subnet_group" "greencity" {
  name       = var.subnet_group_name
  subnet_ids = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]

  tags = var.subnet_tags
}
