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

  # Підмережі для Multi-AZ
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "my-postgres-db"
  }
}

resource "random_password" "rds_password" {
  length  = 16
  special = true
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name   = "rds-postgres-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "db_subnet_group" {
  source  = "terraform-aws-modules/rds/aws//modules/db_subnet_group"
  version = "5.6.0"

  name       = "my-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}