data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)  # Використовуйте кількість підмереж

  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnets, count.index)  # Отримайте окремий CIDR блок
  availability_zone = element(data.aws_availability_zones.available.names, count.index)  # Використовуйте доступні зони

  map_public_ip_on_launch = false
  
  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow internal traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]  # Визначте CIDR блоки для внутрішнього трафіку
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
  value = aws_subnet.private[*].id  # Вихід ID підмереж
}
