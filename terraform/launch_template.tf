resource "aws_launch_template" "app" {
  name_prefix   = "${var.vpc_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  vpc_security_group_ids = [aws_security_group.ec2_private.id]

  user_data = base64encode(<<EOF
#!/bin/bash
set -eux

yum update -y

amazon-linux-extras install -y nginx1
yum install -y amazon-cloudwatch-agent

systemctl enable nginx
systemctl start nginx

mkdir -p /usr/share/nginx/html
echo "Hello from ASG $(hostname)" > /usr/share/nginx/html/index.html

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'EOT'
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/devops/ec2",
            "log_stream_name": "{instance_id}/messages"
          },
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "/devops/ec2",
            "log_stream_name": "{instance_id}/nginx_access"
          }
        ]
      }
    }
  }
}
EOT

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.vpc_name}-asg-instance"
    }
  }
}
