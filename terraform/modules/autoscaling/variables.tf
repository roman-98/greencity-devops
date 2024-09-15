variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "subnets_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the instances in ASG"
  type        = list(string)
}

variable "name" {
  description = "Name prefix for the ASG resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "volume_size" {
  description = "Root EBS volume size"
  type        = number
  default     = 20
}

variable "volume_type" {
  description = "Root EBS volume type"
  type        = string
  default     = "gp2"
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "target_group_arns" {
  description = "List of target group ARNs for load balancing"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "User data script for instances"
  type        = string
  default     = ""
}
