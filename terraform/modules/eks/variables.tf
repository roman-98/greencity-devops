variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "my-eks-cluster"
}

variable "private_subnet_a_id" {
  description = "ID of the private subnet"
}

variable "eks_security_group_id" {
  description = "ID of the EKS security group"
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
}