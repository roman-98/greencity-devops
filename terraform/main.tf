provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "abhi-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  azs = data.aws_availability_zones.available.names
  cluster_name = local.cluster_name
}

module "eks" {
  source            = "./modules/eks"
  cluster_name      = local.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  vpc_security_group_ids = module.vpc.db_security_group_ids  # Передаємо групи безпеки
}


module "rds" {
  source        = "./modules/rds"
  db_instance_identifier = "${local.cluster_name}-db"
  db_username   = var.db_username
  db_password   = var.db_password
  db_name       = var.db_name
  vpc_security_group_ids = module.vpc.db_security_group_ids
  subnet_ids    = module.vpc.private_subnets
}

output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "rds_endpoint" {
  description = "RDS endpoint."
  value       = module.rds.endpoint
}
