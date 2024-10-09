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

  depends_on = [aws_vpc.this]
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.availability_zone_b

  tags = {
    Name = "private_subnet_b"
  }

  depends_on = [aws_subnet.private_subnet_a]
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_a_cidr
  availability_zone       = var.availability_zone_a
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_a"
  }

  depends_on = [aws_subnet.private_subnet_b]
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_b"
  }

  depends_on = [aws_subnet.public_subnet_a]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }

  depends_on = [aws_subnet.public_subnet_b]
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }

  depends_on = [aws_eip.nat]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }

  depends_on = [aws_nat_gateway.this]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }

  depends_on = [aws_route_table.public]
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table.private]
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id

  depends_on = [aws_route_table_association.public_a]
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table_association.public_b]
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private.id

  depends_on = [aws_route_table_association.private_a]
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group for EKS cluster"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "eks_security_group"
  }

  depends_on = [aws_route_table_association.private_b]
}

resource "aws_vpc_security_group_ingress_rule" "eks_http" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "eks_https" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "eks_self" {
  security_group_id            = aws_security_group.eks_sg.id
  referenced_security_group_id = aws_security_group.eks_sg.id
  ip_protocol                  = "-1"
}

resource "aws_vpc_security_group_egress_rule" "eks_to_rds" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = var.private_subnet_a_cidr
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "eks_to_rds_b" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = var.private_subnet_b_cidr
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "eks_outbound" {
  security_group_id = aws_security_group.eks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Security group for RDS instance"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "rds_security_group"
  }

  depends_on = [aws_security_group.eks_sg]
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_subnet_a" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.private_subnet_a_cidr
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_subnet_b" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.private_subnet_b_cidr
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound_vpc" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.cidr_block
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound_subnet_a" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.private_subnet_a_cidr
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound_subnet_b" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = var.private_subnet_b_cidr
  ip_protocol       = "-1"
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]

  tags = {
    Name = "my_db_subnet_group"
  }

  depends_on = [aws_security_group.rds_sg]
}


