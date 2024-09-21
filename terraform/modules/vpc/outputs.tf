output "aws_public_subnet" {
  value = aws_subnet.public_greencity_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.greencity.id
}