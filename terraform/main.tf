data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr  # Передаємо CIDR
  azs          = data.aws_availability_zones.available.names  # Передаємо AZs
  cluster_name = local.cluster_name
}

module "eks" {
  source            = "./modules/eks"
  cluster_name      = local.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group    = aws_security_group.all_worker_mgmt.id
}

module "db_subnet_group" {
  source  = "terraform-aws-modules/rds/aws//modules/db_subnet_group"
  version = "5.6.0"

  name       = "my-db-subnet-group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress" {
  description       = "allow inbound traffic from eks"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

resource "aws_security_group_rule" "all_worker_mgmt_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.all_worker_mgmt.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
