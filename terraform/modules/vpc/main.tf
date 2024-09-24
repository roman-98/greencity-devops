resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "private" {
  count = length(var.azs)
  
  vpc_id            = aws_vpc.this.id
  cidr_block        = [var.private_subnets]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  
  map_public_ip_on_launch = false
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow internal traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
