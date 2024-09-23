variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR діапазон для VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "версія Kubernetes"
  type        = string
  default     = "1.27"
}

variable "db_username" {
  description = "Ім'я користувача для бази даних"
  type        = string
}

variable "db_password" {
  description = "Пароль для бази даних"
  type        = string
}

variable "db_name" {
  description = "Назва бази даних"
  type        = string
}
