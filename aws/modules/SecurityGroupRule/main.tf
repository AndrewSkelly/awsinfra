resource "aws_security_group_rule" "vpc_sg_rule" {
  type        = "ingress"
  from_port   = var.SSH_port
  to_port     = var.SSH_port
  protocol    = var.protocol
  security_group_id = aws_security_group.example_sg.id
  vpc_id      = aws_vpc.example_vpc.id
}