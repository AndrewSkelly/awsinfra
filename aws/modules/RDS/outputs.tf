output "rds_endpoint" {
  value = aws_db_instance.mysqldb.endpoint
  description = "Output the Endpoint URL for instances to make a connection"
}