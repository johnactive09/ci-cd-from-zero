resource "aws_security_group" "ec2_private" {
  name   = "${var.vpc_name}-ec2-private-sg"
  vpc_id = aws_vpc.this.id

  # Allow HTTP only from ALB SG
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Egress anywhere (needed for updates, cw agent, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-ec2-private-sg"
  }
}
