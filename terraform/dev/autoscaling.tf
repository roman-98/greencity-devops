module "autoscaling" {
  source = "../modules/autoscaling"

  region             = "us-west-2"
  env                = "dev"
  name               = "dev-asg"
  ami_id             = "ami-0c55b159cbfafe1f0" 
  instance_type      = "t2.micro"
  key_name           = "your-key-name"         
  subnets_ids        = module.vpc.public_subnets_ids
  security_group_ids = [module.vpc.default_sg]

  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  target_group_arns  = [module.alb.alb_target_group_arn]

  volume_size        = 30
  volume_type        = "gp3"
  
  user_data          = filebase64("path/to/user_data.sh")
}
