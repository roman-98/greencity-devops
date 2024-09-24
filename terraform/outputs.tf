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

output "id" {
  description = "ID групи підмереж"
  value       = aws_db_subnet_group.this.id
}

output "name" {
  description = "Ім'я групи підмереж"
  value       = aws_db_subnet_group.this.name
}
