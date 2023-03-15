output "security_group_id" {
  value = aws_security_group.ec2sec.id
  description = "Output the Security Group ID for use in other modules."
}