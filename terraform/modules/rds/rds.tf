provider "aws" {
  region = var.region
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.db_name}-rds-sg"
  description = "Security Group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_name}-rds-sg"
    Environment = var.env
  }
}

resource "aws_db_instance" "rds_instance" {
  identifier        = var.db_identifier
  engine            = var.db_engine
  instance_class    = var.db_instance_class
  allocated_storage = var.allocated_storage
  db_name              = var.db_name
  username          = var.db_username
  password          = var.db_password
  port              = var.db_port
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  multi_az               = var.multi_az
  storage_encrypted      = var.storage_encrypted
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = false

  tags = {
    Name = var.db_name
    Environment = var.env
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.private_subnets_ids

  tags = {
    Name = "${var.db_name}-subnet-group"
    Environment = var.env
  }
}
