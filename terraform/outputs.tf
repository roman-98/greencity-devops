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
  value       = module.rds_endpoint
}

