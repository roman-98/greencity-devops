output "private_subnet_ids" {
  value = [
    aws_subnet.private-eu-west-3a.id,
    aws_subnet.private-eu-west-3b.id
  ]
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public-eu-west-3a.id,
    aws_subnet.public-eu-west-3b.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}