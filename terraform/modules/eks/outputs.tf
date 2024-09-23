output "cluster_id" {
  description = "ID кластера EKS"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint для керування EKS"
  value       = module.eks.cluster_endpoint
}
