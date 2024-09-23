output "public_subnets" {
  description = "The public subnets"
  value       = aws_subnet.public[*].id
}

