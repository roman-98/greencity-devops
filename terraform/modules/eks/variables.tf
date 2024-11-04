variable "vpc_id" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets IDs"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnets IDs"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_sg_name" {
  description = "ID of the cluster security group"
  type        = string
}

variable "eks_node_sg_name" {
  description = "ID of the nodes security group"
  type        = string
}
