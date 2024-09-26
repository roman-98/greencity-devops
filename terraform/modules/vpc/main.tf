resource "aws_vpc" "this" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.availability_zone_a

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks_security_group"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 5432  
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.private_subnet_a_cidr, var.private_subnet_b_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block, var.private_subnet_a_cidr, var.private_subnet_b_cidr]
  }

  tags = {
    Name = "rds_security_group"
  }
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "my_db_subnet_group"
  }
}
