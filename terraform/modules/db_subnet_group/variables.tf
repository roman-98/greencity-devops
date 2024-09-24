variable "name" {
  description = "Назва групи підмереж"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID підмереж для групи підмереж"
  type        = list(string)
}
