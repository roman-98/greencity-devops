variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "private_subnet_a_id" {
  description = "ID of the first private subnet"
  type        = string
}

variable "private_subnet_b_id" {
  description = "ID of the second private subnet"
  type        = string
}

variable "eks_security_group_id" {
  description = "ID of the EKS security group"
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

