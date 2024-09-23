output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnets" {
  description = "The private subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnets" {
  description = "The public subnets"
  value       = aws_subnet.public[*].id
}

output "db_security_group_ids" {
  description = "The security group IDs for the database"
  value       = aws_security_group.db_security_group.id
}
