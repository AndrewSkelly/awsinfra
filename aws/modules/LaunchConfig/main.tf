# Create an EC2 instance launch configuration.
resource "aws_launch_configuration" "cars-api-launch-config" {
  name                 = "my-launch-config"
  image_id             = "ami-0e1dc7c0757fa9cdc"
  instance_type        = "t2.micro"
  # associate_public_ip_address = true
  key_name             = var.key_name
  security_groups      = [var.security_group_id]
}