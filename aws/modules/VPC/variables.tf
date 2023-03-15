variable "cidr_block" {
    type = string
    default     = "10.0.0.0/24"
    # First Useable IP 10.0.0.1
    # Last Useable IP 10.0.0.254
    description = "CIDR Block with 256 Total Hosts"
}