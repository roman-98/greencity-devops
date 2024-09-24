variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}
