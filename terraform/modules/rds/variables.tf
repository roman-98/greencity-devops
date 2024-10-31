variable name {
  description = "Name of the RDS instance"
  type        = string
  default     = "greencity"
}

variable subnet_ids {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable vpc_id {
  description = "VPC ID for the RDS instance"
  type        = string
}

variable allocated_storage {
  description = "The allocate storage in gigabytes"
  type        = number
  default     = 20
}

variable engine {
  description = "The type of database engine"
  type        = string
  default     = "postgres"
}

variable engine_version {
  description = "The engine version for the database"
  type        = string
  default     = "16"
}

variable instance_class {
  description = "The instance type to use"
  type        = string
  default     = "db.t3.medium"
}

variable db_name {
  description = "The name of the database to create"
  type        = string
  default     = "greencity"
}

variable db_username {
  description = "The master username for the DB instance"
  type        = string
  sensitive   = true
}

variable db_password {
  description = "The master password for the DB instance"
  type        = string
  sensitive   = true
}

variable db_port {
  description = "The port on which the database will be accessible"
  type        = number
  default     = 5432
}
