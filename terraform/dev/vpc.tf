module "vpc" {
  source = "../modules/vpc"

  region   = "eu-west-3"
  env      = "dev"
  vpc_cidr = "10.0.0.0/16"

  public_subnet_az1_cidr = "10.0.1.0/24"
  public_subnet_az2_cidr = "10.0.2.0/24"
  public_subnet_az3_cidr = "10.0.3.0/24"

  private_app_subnet_az1_cidr = "10.0.10.0/24"
  private_app_subnet_az2_cidr = "10.0.20.0/24"
  private_app_subnet_az3_cidr = "10.0.30.0/24"

  private_database_subnet_az1_cidr = "10.0.100.0/24"
  private_database_subnet_az2_cidr = "10.0.110.0/24"
  private_database_subnet_az3_cidr = "10.0.120.0/24"

  public_route_table_cidr       = "0.0.0.0/0"
  private_route_table_az1_cidr  = "0.0.0.0/0"
  private_route_table_az2_cidr  = "0.0.0.0/0"
  private_route_table_az3_cidr  = "0.0.0.0/0"
  database_route_table_cidr     = "10.0.0.0/16"
}
