resource "aws_subnet" "public_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/25" # Replace with your desired CIDR block for the subnet
  availability_zone       = "eu-west-1a"  # Replace with your desired availability zone
  map_public_ip_on_launch = true          # Enables public IP assignment for instances launched in this subnet

  tags = {
    Name = "ITM-Public"
  }
}
