output "endpoint" {
  description = "The connection endpoint for the database."
  value       = aws_db_instance.default.endpoint
}
