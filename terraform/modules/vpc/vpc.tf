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

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }

  depends_on = [aws_vpc.vpc]

}

resource "aws_eip" "eip-for-nat-gateway-az1" {
  domain   = "vpc"

  tags   = {
    Name = "${var.env}-eip-az1-ngw-az1"
  }
}

resource "aws_eip" "eip-for-nat-gateway-az2" {
  domain   = "vpc"

  tags   = {
    Name = "${var.env}-eip-az2-ngw-az2"
  }
}

resource "aws_eip" "eip-for-nat-gateway-az3" {
  domain   = "vpc"

  tags   = {
    Name = "${var.env}-eip-az3-ngw-az3"
  }
}

resource "aws_nat_gateway" "nat-gateway-az1" {
  allocation_id = aws_eip.eip-for-nat-gateway-az1.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags   = {
    Name = "${var.env}-ngw-az1-pub-sbnt-az1"
  }

  depends_on = [aws_route_table.public_route_table]

}

resource "aws_nat_gateway" "nat-gateway-az2" {
  allocation_id = aws_eip.eip-for-nat-gateway-az2.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags   = {
    Name = "${var.env}-ngw-az2-pub-sbnt-az2"
  }

  depends_on = [aws_nat_gateway.nat-gateway-az1]

}

resource "aws_nat_gateway" "nat-gateway-az3" {
  allocation_id = aws_eip.eip-for-nat-gateway-az3.id
  subnet_id     = aws_subnet.public_subnet_az3.id

  tags   = {
    Name = "${var.env}-ngw-az3-pub-sbnt-az3"
  }

  depends_on = [aws_nat_gateway.nat-gateway-az2]

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_route_table_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }

  depends_on = [aws_subnet.public_subnet_az3]

}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-az1"
  }

  depends_on = [aws_internet_gateway.internet_gateway]

}

resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = []

}

resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-az2"
  }

  depends_on = [aws_subnet.public_subnet_az1]

}

resource "aws_route_table_association" "public_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = []

}

resource "aws_subnet" "public_subnet_az3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az3_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-subnet-az3"
  }

  depends_on = [aws_subnet.public_subnet_az2]

}

resource "aws_route_table_association" "public_subnet_az3_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az3.id
  route_table_id = aws_route_table.public_route_table.id

  depends_on = []

}

resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-app-az1"
  }

  depends_on = [aws_nat_gateway.nat-gateway-az3]

}

resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = var.private_route_table_az1_cidr
    nat_gateway_id  = aws_nat_gateway.nat-gateway-az1.id
  }

  tags   = {
    Name = "${var.env}-private-rt-az1"
  }

  depends_on = [aws_subnet.private_app_subnet_az3]

}

resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = aws_subnet.private_app_subnet_az1.id
  route_table_id    = aws_route_table.private_route_table_az1.id

  depends_on = []

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
    nat_gateway_id  = aws_nat_gateway.nat-gateway-az2.id
  }

  tags   = {
    Name = "${var.env}-private-rt-az2"
  }

  depends_on = [aws_route_table.private_route_table_az1]

}

resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = aws_subnet.private_app_subnet_az2.id
  route_table_id    = aws_route_table.private_route_table_az2.id

  depends_on = []

}

resource "aws_subnet" "private_app_subnet_az3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_app_subnet_az3_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-app-az3"
  }

  depends_on = [aws_subnet.private_app_subnet_az2]

}

resource "aws_route_table" "private_route_table_az3" {
  vpc_id            = aws_vpc.vpc.id

  route {
    cidr_block      = var.private_route_table_az3_cidr
    nat_gateway_id  = aws_nat_gateway.nat-gateway-az3.id
  }

  tags   = {
    Name = "${var.env}-private-rt-az3"
  }

  depends_on = [aws_route_table.private_route_table_az2]

}

resource "aws_route_table_association" "private_app_subnet_az3_route_table_az3_association" {
  subnet_id         = aws_subnet.private_app_subnet_az3.id
  route_table_id    = aws_route_table.private_route_table_az3.id

  depends_on = []

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

  depends_on = [aws_subnet.private_database_subnet_az3]

}

resource "aws_subnet" "private_database_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_database_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-database-az1"
  }

  depends_on = [aws_route_table.private_route_table_az3]

}

resource "aws_route_table_association" "private_database_subnet_az1_route_table_association" {
  subnet_id         = aws_subnet.private_database_subnet_az1.id
  route_table_id    = aws_route_table.database_route_table.id

  depends_on = []

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

  depends_on = []

}

resource "aws_subnet" "private_database_subnet_az3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_database_subnet_az3_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[2]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.env}-private-database-az3"
  }

  depends_on = [aws_subnet.private_database_subnet_az2]

}

resource "aws_route_table_association" "private_database_subnet_az3_route_table_association" {
  subnet_id         = aws_subnet.private_database_subnet_az3.id
  route_table_id    = aws_route_table.database_route_table.id

  depends_on = []

}