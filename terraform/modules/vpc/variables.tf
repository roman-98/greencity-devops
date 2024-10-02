variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "The name tag for the VPC."
  type        = string
  default     = "main_vpc"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A."
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B."
  type        = string
  default     = "10.0.4.0/24"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B."
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_a" {
  description = "Availability zone for private subnet A."
  type        = string
  default     = "eu-west-3a"
}

variable "availability_zone_b" {
  description = "Availability zone for private subnet B."
  type        = string
  default     = "eu-west-3b"
}
