resource "aws_db_instance" "default" {
  identifier          = var.db_instance_identifier
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage   = 20
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = var.vpc_security_group_ids
  username           = var.db_username
  password           = var.db_password
  db_name            = var.db_name
  multi_az           = true
  skip_final_snapshot = true

  tags = {
    Name = "${var.db_instance_identifier}-instance"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.db_instance_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.db_instance_identifier}-subnet-group"
  }
}

output "endpoint" {
  value = aws_db_instance.default.endpoint
}
