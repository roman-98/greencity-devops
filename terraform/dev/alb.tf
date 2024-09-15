module "alb" {
  source = "../modules/alb"

  region               = "eu-west-3"
  env                  = "dev"
  vpc_id               = module.vpc.vpc_id 
  public_subnets_ids   = module.vpc.public_subnets_ids
  alb_name             = "dev-alb"
  allowed_cidr_blocks  = ["0.0.0.0/0"] 

  target_group_port    = 80
  health_check_path    = "/health"
  allowed_hosts        = ["example.com", "dev.example.com"]

  enable_deletion_protection = false
}
