resource "aws_db_instance" "my_db" {
  identifier              = "my-database"
  engine                 = "postgres"  
  engine_version         = "16"  
  instance_class         = "db.t3.micro"
  allocated_storage       = 20
  storage_type           = "gp2"
  username               = "postgres"
  password               = "yourpassword" 
  db_name                = "mydb"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_db_subnet_group.name
  skip_final_snapshot    = true

  multi_az = true

  tags = {
    Name = "my_database"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my_db_subnet_group"
  subnet_ids = ["10.0.2.0/24", "10.0.4.0/24"]

  tags = {
    Name = "my_db_subnet_group"
  }
}