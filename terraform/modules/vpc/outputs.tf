output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "private_subnet_a_id" {
  description = "The ID of the private subnet A."
  value       = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  description = "The ID of the private subnet B."
  value       = aws_subnet.private_subnet_b.id
}

output "public_subnet_a_id" {
  description = "The ID of the public subnet A."
  value       = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  description = "The ID of the public subnet B."
  value       = aws_subnet.public_subnet_b.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.this.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.this.id
}

output "eks_security_group_id" {
  description = "The security group ID for EKS."
  value       = aws_security_group.eks_sg.id
}

output "rds_security_group_id" {
  description = "The security group ID for RDS."
  value       = aws_security_group.rds_sg.id
}

output "rds_subnet_group_name" {
  description = "The subnet group name for RDS."
  value       = aws_db_subnet_group.my_db_subnet_group.name
}

