variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks."
  type        = list(string)  # Це має бути список рядків
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  description = "List of availability zones."
  type        = list(string)
}
