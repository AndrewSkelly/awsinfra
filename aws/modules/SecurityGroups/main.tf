resource "aws_security_group" "ec2sec" {
  name_prefix = "ec2sec"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.SSH_port
    to_port     = var.SSH_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  ingress {
    from_port   = var.HTTP_port
    to_port     = var.HTTP_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  egress {
    from_port   = var.HTTP_port
    to_port     = var.HTTP_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  ingress {
    from_port   = var.HTTPS_port
    to_port     = var.HTTPS_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  egress {
    from_port   = var.HTTPS_port
    to_port     = var.HTTPS_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  ingress {
    from_port   = var.MySQL_port
    to_port     = var.MySQL_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }

  egress {
    from_port   = var.MySQL_port
    to_port     = var.MySQL_port
    protocol    = var.protocol
    cidr_blocks = [var.cidr_blocks[0]]
  }
}