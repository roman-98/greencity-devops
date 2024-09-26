output "rds_endpoint" {
  description = "The endpoint of the RDS instance."
  value       = aws_db_instance.greencity.endpoint
}

output "rds_instance_id" {
  description = "The ID of the RDS instance."
  value       = aws_db_instance.greencity.id
}

output "rds_subnet_group_name" {
  description = "The name of the DB subnet group."
  value       = aws_db_subnet_group.greencity.name
}
