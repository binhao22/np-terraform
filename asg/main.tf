# asg 생성
resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.name
  vpc_zone_identifier  = var.subnets

  # ELB 타겟그룹 연결
  health_check_type = var.health_check_type
  target_group_arns = [ var.lb_tg ]
  min_size          = var.min_size
  max_size          = var.max_size

  tag {
    key                 = "Name"
    value               = "np-asg"
    propagate_at_launch = true  # 최초 인스턴스 실행시 템플릿 적용
  }
}

# 시작템플릿 생성
resource "aws_launch_configuration" "this" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [ var.security_group ]

  # nginx 웹서버 설치
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install nginx -y 
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  # 새 인스턴스 생성 후, 기존 인스턴스 삭제
  lifecycle {
    create_before_destroy = true
  }
}