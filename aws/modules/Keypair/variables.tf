variable "key_name" {
    type = string
    default     = "CarsAPIsKeyPair"
}
# Variable to store the Private Key imported from PrivateKey module
variable "public_key" {
    type = string
}