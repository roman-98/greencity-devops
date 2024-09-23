variable "db_instance_identifier" {
  description = "Ідентифікатор екземпляра бази даних"
  type        = string
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

variable "db_subnet_ids" {
  description = "Список ID підмереж для RDS"
  type        = list(string)  # Це потрібно для підмережі бази даних
}

variable "vpc_security_group_ids" {
  description = "Список ID груп безпеки для RDS"
  type        = list(string)  # Це потрібно для групи безпеки
}
