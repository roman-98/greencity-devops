variable "cluster_name" {
  description = "Name of the EKS cluster"
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
