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
    Name = "np-asg"
    propagate_at_launch = true
  }
}

# AMI 접근
data "aws_ami" "centos7" {
  most_recent = true
  owners = ["679593333241"]
  
  filter {
    name   = "name"
    values = ["CentOS Linux 7*x86_64*"]
  }
}

# 시작템플릿 생성
resource "aws_launch_configuration" "this" {
  image_id        = data.aws_ami.centos7.id
  instance_type   = "t2.micro"
  security_groups = [ var.security_group ]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y 
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF

  lifecycle {
    create_before_destroy = true
  }
}