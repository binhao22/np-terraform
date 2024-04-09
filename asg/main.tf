# asg 생성
resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnets

  # ELB 타겟그룹 연결
  health_check_type = "ELB"
  target_group_arns = [ var.lb_tg ]
  min_size = 1
  max_size = 2

  tag {
    key = "Name"
    value = "np-asg"
    propagate_at_launch = true
  }
}

# 시작템플릿 생성
resource "aws_launch_configuration" "this" {
  image_id        = "ami-0c031a79ffb01a803"  # Amazon Linux 2023
  instance_type   = "t2.micro"
  security_groups = [ var.security_group ]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo vi /etc/yum.repos.d/nginx.repo
              sudo yum install nginx -y 
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  lifecycle {
    create_before_destroy = true
  }
}