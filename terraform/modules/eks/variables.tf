variable "cluster_name" {
  description = "Назва кластера EKS"
  type        = string
}

variable "kubernetes_version" {
  description = "Версія Kubernetes"
  type        = string
}

variable "vpc_id" {
  description = "ID VPC, де буде розгорнуто EKS"
  type        = string
}

variable "private_subnets" {
  description = "Приватні підмережі в VPC"
  type        = list(string)
}

variable "security_group" {
  description = "Security group для EKS"
  type        = string
}
