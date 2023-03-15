output "private_key" {
  value     = tls_private_key.privkey.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.privkey.public_key_openssh
}