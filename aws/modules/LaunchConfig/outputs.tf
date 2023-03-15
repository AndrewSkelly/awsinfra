output "LaunchConfigName" {
  value = aws_launch_configuration.cars-api-launch-config.name
  description = "Export the ID of the Launch Config"
}