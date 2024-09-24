variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = string
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
