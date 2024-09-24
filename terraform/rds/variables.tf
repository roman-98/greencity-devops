variable "db_parameter_group_name" {
  description = "Name of the DB parameter group"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch the cluster in"
  type        = list(string)
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
}

variable "db_name" {
  description = "Name for the database"
  type        = string
  default = "greencity"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default = "postgres"
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  default = "password"
}

variable "security_group_id" {
  description = "The ID of the security group to associate with the RDS cluster"
  type        = string
}