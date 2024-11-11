resource "aws_db_subnet_group" "main" {
  name       = var.db_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.name}-subnet-group"
  }
}

resource "aws_security_group" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}-security-group"
  }
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = var.db_port
  ip_protocol       = "-1"
  to_port           = var.db_port
}

resource "aws_db_instance" "greencity" {
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.main.id]
  publicly_accessible     = false
  skip_final_snapshot     = true
  
  tags = {
    Name = "${var.name}-instance"
  }
}

resource "aws_secretsmanager_secret_version" "greencity_secrets_v1" {
  secret_id     = "prod/greencity-secrets-v1"

  secret_string = jsonencode({
    DATASOURCE_URL = format("jdbc:postgresql://%s/greencity", aws_db_instance.greencity.endpoint)
  })

  depends_on = [aws_db_instance.greencity]
}

