variable "db_parameter_group_name" {
  description = "Name of the DB parameter group"
  type        = string
}

variable "family" {
  description = "The DB parameter group family"
  type        = string
  default     = "postgres13"
}
