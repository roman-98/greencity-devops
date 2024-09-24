resource "aws_db_subnet_group" "default" {
  name       = "${var.cluster_name}-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.cluster_name}-rds-subnet-group"
  }
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier      = "${var.cluster_name}-rds-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "14.5"
  availability_zones      = var.azs
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  skip_final_snapshot     = true

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${var.cluster_name}-rds-cluster"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "${var.cluster_name}-rds-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = "db.r5.large"
  engine             = aws_rds_cluster.postgresql.engine
  engine_version     = aws_rds_cluster.postgresql.engine_version
}

resource "aws_db_parameter_group" "postgresql" {
  family = "aurora-postgresql14"
  name   = "${var.cluster_name}-db-parameter-group"

  parameter {
    name  = "log_connections"
    value = "1"
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

