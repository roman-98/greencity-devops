provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-app-az1"
  }

  depends_on = [aws_vpc.vpc]

}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = var.private_route_table_az1_cidr
  }

  tags   = {
    Name = "${var.env}-private-rt-az1"
  }

  depends_on = [aws_subnet.private_app_subnet_az3]

}

resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_app_subnet_az1.id
  route_table_id    = aws_route_table.private_route_table_az1.id

  depends_on = [aws_route_table.private_route_table_az1]

}

resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-app-az2"
  }

  depends_on = [aws_subnet.private_app_subnet_az1]

}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = var.private_route_table_az2_cidr
  }

  tags   = {
    Name = "${var.env}-private-rt-az2"
  }

  depends_on = [aws_route_table.private_route_table_az1]

}

resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_app_subnet_az2.id
  route_table_id    = aws_route_table.private_route_table_az2.id

  depends_on = [aws_route_table.private_route_table_az2]

}

resource "aws_route_table" "database_route_table" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = var.database_route_table_cidr
    gateway_id      = "local"
  }

  tags   = {
    Name = "${var.env}-database-rt"
  }

  depends_on = [aws_subnet.private_database_subnet_az2]

}

resource "aws_subnet" "private_database_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_database_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-database-az1"
  }

  depends_on = [aws_route_table.private_route_table_az2]

}

resource "aws_route_table_association" "private_database_subnet_az1_route_table_association" {
  subnet_id         = aws_subnet.private_database_subnet_az1.id
  route_table_id    = aws_route_table.database_route_table.id

  depends_on = [aws_subnet.private_database_subnet_az1]

}

resource "aws_subnet" "private_database_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_database_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-database-az2"
  }

  depends_on = [aws_subnet.private_database_subnet_az1]

}

resource "aws_route_table_association" "private_database_subnet_az2_route_table_association" {
  subnet_id         = aws_subnet.private_database_subnet_az2.id
  route_table_id    = aws_route_table.database_route_table.id

  depends_on = [aws_subnet.private_database_subnet_az2]

}
