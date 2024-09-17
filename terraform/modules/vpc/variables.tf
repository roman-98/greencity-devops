variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  default     = ""
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_route_table_az1_cidr" {
  description = "CIDR block for the private route table in Availability Zone 1"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_route_table_az2_cidr" {
  description = "CIDR block for the private route table in Availability Zone 2"
  type        = string
  default     = "0.0.0.0/0"
}

variable "database_route_table_cidr" {
  description = "CIDR block for the database route table"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_app_subnet_az1_cidr" {
  description = "CIDR block for the private application subnet in Availability Zone 1"
  type        = string
  default     = "10.0.10.0/24"
}

variable "private_app_subnet_az2_cidr" {
  description = "CIDR block for the private application subnet in Availability Zone 2"
  type        = string
  default     = "10.0.20.0/24"
}

variable "private_database_subnet_az1_cidr" {
  description = "CIDR block for the private database subnet in Availability Zone 1"
  type        = string
  default     = "10.0.100.0/24"
}

variable "private_database_subnet_az2_cidr" {
  description = "CIDR block for the private database subnet in Availability Zone 2"
  type        = string
  default     = "10.0.110.0/24"
}
