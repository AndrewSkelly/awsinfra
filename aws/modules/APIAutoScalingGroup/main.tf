# Create an Auto Scaling group with a minimum and maximum of 2 instances.
resource "aws_autoscaling_group" "carApiAutoscale" {
  name                 = "carApiAutoscale"
  vpc_zone_identifier = [var.public_subnet_id]
  launch_configuration = var.LaunchConfigName
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2

  #   # Attach the instances to the Target Group
  # lifecycle {
  #   create_before_destroy = true
  # }

  # tag {
  #   key                 = "Name"
  #   value               = "carApiInstance"
  #   propagate_at_launch = true
  # }

  # target_group_arns = [aws_lb_target_group.carApiTargetGroup.arn]
}