variable "vpc_cidr" {
  description = "CIDR діапазон для VPC"
  type        = string
}

variable "azs" {
  description = "Список доступних зон"
  type        = list(string)
}

variable "cluster_name" {
  description = "Назва кластера EKS"
  type        = string
}
