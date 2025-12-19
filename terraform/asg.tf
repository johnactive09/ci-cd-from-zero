resource "aws_autoscaling_group" "app" {
  name                = "${var.vpc_name}-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 2
  vpc_zone_identifier = aws_subnet.private[*].id

  health_check_type         = "ELB"
  health_check_grace_period = 120

  target_group_arns = [aws_lb_target_group.app.arn]

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.vpc_name}-asg"
    propagate_at_launch = true
  }
}
