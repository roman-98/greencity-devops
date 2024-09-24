resource "aws_db_instance" "my_db" {
  identifier              = "my-database"
  engine                 = "postgres"  # Змініть на "mysql" для MySQL
  engine_version         = "14.2"  # Змініть на актуальну версію
  instance_class         = "db.t3.micro"
  allocated_storage       = 20
  storage_type           = "gp2"
  username               = "admin"
  password               = "yourpassword"  # Змініть на сильний пароль
  db_name                = "mydb"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot    = true

  tags = {
    Name = "my_database"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my_db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id]

  tags = {
    Name = "my_db_subnet_group"
  }
}
