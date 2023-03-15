# Create Subnet Group to be applied to
resource "aws_db_subnet_group" "cars_db_subnet" {
  name        = "cars_db_subnet"
  subnet_ids  = [var.private_subnet_id, var.private_subnet_b_id]
}
# Create SQL Database
# This will store car info and associated penalty points
resource "aws_db_instance" "mysqldb" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name = aws_db_subnet_group.cars_db_subnet.name
}