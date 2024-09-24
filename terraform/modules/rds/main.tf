resource "aws_db_instance" "this" {
  identifier        = var.db_identifier
  instance_class    = var.db_instance_class
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0"
  username          = var.db_user
  password          = var.db_password
  db_name           = var.db_name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  depends_on = [aws_vpc.this]
}

output "db_endpoint" {
  value = aws_db_instance.this.endpoint
}
