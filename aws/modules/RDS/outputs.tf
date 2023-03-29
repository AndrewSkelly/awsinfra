output "rds_endpoint" {
  value = aws_db_instance.mysqldb.endpoint
  description = "Output the Endpoint URL for instances to make a connection"
}

output "username" {
  value = aws_db_instance.mysqldb.username
}

output "password" {
  value = aws_db_instance.mysqldb.password
}