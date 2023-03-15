resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  # Public key match generated from the private key
  public_key = var.public_key
}
