output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "region" {
  value = var.aws_region
}

output "rds_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = module.rds.this_db_instance_endpoint
}

output "rds_password" {
  description = "Пароль для PostgreSQL RDS"
  value       = random_password.rds_password.result
  sensitive   = true
}

