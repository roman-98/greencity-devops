variable region {
  type        = string
  default     = "eu-west-3"
  description = "AWS region to deploy to"
}

variable vpc_cidr_block {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable cluster_name {
  type        = string
  description = "EKS cluster name"
}