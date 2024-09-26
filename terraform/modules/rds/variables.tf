variable "identifier" {
  description = "The identifier for the RDS instance."
  type        = string
  default = "greencity-database"
}

variable "engine" {
  description = "The database engine to use."
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "The engine version for the database."
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "The instance type to use."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The amount of storage (in GB) to allocate for the DB instance."
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "The storage type to use for the DB instance."
  type        = string
  default     = "gp2"
}

variable "username" {
  description = "The master username for the DB instance."
  type        = string
}

variable "password" {
  description = "The master password for the DB instance."
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
  default = "greencity"
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the DB instance."
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The name for the DB subnet group."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to place in the subnet group."
  type        = list(string)
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final DB snapshot before deletion."
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ support for the DB instance."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to the DB instance."
  type        = map(string)
  default     = {
    Name = "my_database"
  }
}

variable "subnet_tags" {
  description = "A map of tags to apply to the DB subnet group."
  type        = map(string)
  default     = {
    Name = "my_db_subnet_group"
  }
}
