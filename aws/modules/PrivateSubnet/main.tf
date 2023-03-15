resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.128/26" # The second subnet will use the last 128 IPs
  availability_zone       = "eu-west-1a"    # Replace with your desired availability zone
  map_public_ip_on_launch = false           # Disables public IP assignment for instances launched in this subnet

  tags = {
    Name = "ITM-Private"
  }
}
