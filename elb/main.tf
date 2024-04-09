# lb 생성
resource "aws_lb" "this" {
  load_balancer_type = var.lb_type
  internal           = var.internal
  subnets            = var.subnets
  security_groups    = [ var.security_group ]

  tags = {
    Name = "np-alb"
  }
}

# 타겟그룹 생성
resource "aws_lb_target_group" "this" {
  vpc_id   = var.vpc_id
  port     = var.tg_port
  protocol = var.tg_protocol

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "np-tg"
  }
}

# 리스너 생성
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  # 5xx 장애 리턴
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "503"
    }
  }

  tags = {
    Name = "np-lb-listener"
  }
}

# 리스너 룰 생성
resource "aws_lb_listener_rule" "this" {
  listener_arn = aws_lb_listener.this.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  # 타겟그룹으로 트래픽 전달
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
