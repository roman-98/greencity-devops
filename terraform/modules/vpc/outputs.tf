output "vpc_id" {
  description = "ID VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Приватні підмережі"
  value       = module.vpc.private_subnets
}
