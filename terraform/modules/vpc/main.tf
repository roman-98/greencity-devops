resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "private" {
  count = length(var.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.cluster_name}-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone = var.azs[count.index]

  tags = {
    Name = "${var.cluster_name}-public-${count.index}"
  }
}

resource "aws_security_group" "db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.cluster_name}-db-sg"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "db_security_group_ids" {
  value = [aws_security_group.db.id]
}
