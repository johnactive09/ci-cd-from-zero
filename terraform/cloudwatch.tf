resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/devops/ec2"
  retention_in_days = 7
}
