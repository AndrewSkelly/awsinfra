output "autoScalingGroupId" {
  value = aws_autoscaling_group.carApiAutoscale.id
  description = "Export the ID of the Auto Scaling Group"
}