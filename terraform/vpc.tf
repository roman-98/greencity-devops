resource "aws_vpc" "greencity" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "greencity_vpc"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = vpc.greencity.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = vpc.greencity.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet_b"
  }
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.greencity.id

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
  vpc_id = aws_vpc.greencity.id

  ingress {
    from_port   = 5432 
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24", "10.0.4.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16", "10.0.2.0/24", "10.0.4.0/24"]
  }

  tags = {
    Name = "rds_security_group"
  }
}


output "vpc_id" {
  value = aws_vpc.greencity.id
}