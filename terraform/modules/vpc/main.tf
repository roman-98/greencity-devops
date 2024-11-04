resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "K8svpc"
  }
}

resource "aws_subnet" "private-eu-west-3a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-3a"

  tags = {
    "Name"                                      = "private-eu-west-3a"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes/io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private-eu-west-3b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-3b"

  tags = {
    "Name"                                      = "private-eu-west-3b"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes/io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-3a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-3a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-eu-west-3a"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes/io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "public-eu-west-3b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-3b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-eu-west-3b"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes/io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "k8svpc-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public-eu-west-3a.id

  tags = {
    Name = "k8s-nat"
  }


  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block        = "0.0.0.0/0"
    nat_gateway_id    = aws_nat_gateway.main.id 
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block        = "0.0.0.0/0"
    nat_gateway_id    = aws_nat_gateway.main.id 
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private-eu-west-3a" {
  subnet_id = aws_subnet.private-eu-west-3a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-eu-west-3b" {
  subnet_id = aws_subnet.private-eu-west-3a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-eu-west-3a" {
  subnet_id = aws_subnet.public-eu-west-3a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-eu-west-3b" {
  subnet_id = aws_subnet.public-eu-west-3a.id
  route_table_id = aws_route_table.public.id
}