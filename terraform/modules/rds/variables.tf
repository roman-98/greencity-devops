variable "db_instance_identifier" {
  description = "Ідентифікатор DB екземпляра"
  type        = string
}

variable "db_username" {
  description = "Ім'я користувача для доступу до бази даних"
  type        = string
}

variable "db_password" {
  description = "Пароль для доступу до бази даних"
  type        = string
}

variable "db_name" {
  description = "Назва бази даних"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Список ID груп безпеки для RDS"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Список підмереж для RDS"
  type        = list(string)
}
