variable "region" {
  description = "Region to deploy EKS"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be deployed"
  type        = string
}

variable "public_subnets_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "eks_role_arn" {
  description = "ARN of the EKS cluster IAM role (created externally)"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for EKS worker nodes (created externally)"
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
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

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "SSH key name to access worker nodes"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.21"
}
