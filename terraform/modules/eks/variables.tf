variable "cluster_name" {
  description = "Назва кластера EKS"
  type        = string
}

variable "kubernetes_version" {
  default     = 1.27
  description = "версія Kubernetes"
}

variable "private_subnets" {
  description = "Список приватних підмереж"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID VPC"
  type        = string
}
