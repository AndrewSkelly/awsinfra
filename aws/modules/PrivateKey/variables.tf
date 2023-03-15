variable "algorithm" {
    type = string
    default     = "RSA"
    description = "Type of encryption algorithm used"
}

variable "rsa_bits" {
    type = number
    default     = 2048
    description = "number of bits used in key"
}