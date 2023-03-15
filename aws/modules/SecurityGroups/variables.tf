variable "vpc_id" {
  type        = string
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "Protocol used for ALL security groups"
}

variable "cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
  description = "Security groups applied to this Database"
}

variable "SSH_port" {
  type        = number
  default     = 22
  description = "The port used for SSH"
}

variable "HTTP_port" {
  type        = number
  default     = 80
  description = "The port used for HTTP"
}

variable "HTTPS_port" {
  type        = number
  default     = 443
  description = "The port used for HTTPS"
}

variable "MySQL_port" {
  type        = number
  default     = 3306
  description = "The port used for MySQL"
}