variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR for the VPC"
}

variable "aws_region" {
  default     = "us-west-1"
  description = "AWS region"
}

variable "kubernetes_version" {
  default     = "1.27"
  description = "Version of Kubernetes for the EKS cluster"
}
