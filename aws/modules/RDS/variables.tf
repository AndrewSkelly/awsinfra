# Variables for the MySql Database #
####################################
variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The storage that this database will have available"
}

variable "engine" {
  type        = string
  default     = "mysql"
  description = "The database engine selected"
}

variable "engine_version" {
  type    = string
  default = "8.0.23"
  description = "The database engine version selected"
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
  description = "The instance type of the database"
}

variable "db_name" {
  type    = string
  default = "cars_db"
  description = "The name of the database"
}

variable "username" {
  type    = string
  default = "admin"
  description = "Username credential for database"
}

variable "password" {
  type    = string
  default = "TUDproj23"
  description = "Password credential for database"
}

variable "publicly_accessible" {
  type    = bool
  default = false
  description = "make database publicly available"
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
}

# Variable to store the Security Group ID imported from SecurityGroups module
variable "security_group_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "private_subnet_b_id" {
  type = string
}