resource "tls_private_key" "privkey" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}