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

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]  # Залиште CIDR-адреси або змініть їх на інші, якщо потрібно
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]  # Змінено CIDR-адреси для уникнення конфліктів
}