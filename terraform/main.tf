data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr  # Передаємо CIDR
  azs          = data.aws_availability_zones.available.names  # Передаємо AZs
  cluster_name = local.cluster_name
}

module "eks" {
  source            = "./modules/eks"
  cluster_name      = local.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group    = aws_security_group.all_worker_mgmt.id
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress" {
  description       = "allow inbound traffic from eks"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

resource "aws_security_group_rule" "all_worker_mgmt_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.all_worker_mgmt.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds_security_group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "rds_security_group"
  }
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier         = "my-postgres-db"
  engine             = "postgres"
  engine_version     = "13.4"
  instance_class     = "db.t3.medium"
  allocated_storage  = 20
  storage_type       = "gp2"
  username           = "admin"
  password           = random_password.rds_password.result
  multi_az           = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = module.db_subnet_group.this_db_subnet_group_name

  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "my-postgres-db"
  }
}

output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_password" {
  description = "Пароль для PostgreSQL RDS"
  value       = random_password.rds_password.result
  sensitive   = true
}
