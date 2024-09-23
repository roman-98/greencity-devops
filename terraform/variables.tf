variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR для VPC"
}

variable "aws_region" {
  default     = "us-west-1"
  description = "Регіон AWS"
}

variable "kubernetes_version" {
  default     = "1.27"
  description = "Версія Kubernetes для EKS"
}
