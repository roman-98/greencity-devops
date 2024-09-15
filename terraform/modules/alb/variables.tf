variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where ALB will be created"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access ALB"
  type        = list(string)
}

variable "target_group_port" {
  description = "The port the target group listens on"
  type        = number
}

variable "health_check_path" {
  description = "The path used for health checks"
  type        = string
  default     = "/"
}

variable "allowed_hosts" {
  description = "List of allowed host headers for ALB routing"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}
