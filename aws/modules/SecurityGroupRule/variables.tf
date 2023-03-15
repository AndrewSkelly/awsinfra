variable "protocol" {
  type        = string
  default     = "tcp"
  description = "Protocol used for ALL security groups"
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