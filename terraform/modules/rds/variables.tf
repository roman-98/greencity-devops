variable "region" {
  description = "AWS region"
  type        = string
}

variable "env" {
  description = "Environment (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where RDS will be created"
  type        = string
}

variable "private_subnets_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_engine" {
  description = "The database engine to use (e.g. mysql, postgres)"
  type        = string
}

variable "db_instance_class" {
  description = "Instance class for RDS (e.g. db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "The size of the database (in GB)"
  type        = number
}

variable "db_username" {
  description = "Master username for the RDS"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port for the RDS instance"
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access RDS"
  type        = list(string)
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot before deletion"
  type        = bool
  default     = true
}
