# alb 생성
resource "aws_lb" "this" {
  load_balancer_type = "application"
  internal           = false
  subnets            = [ "${var.subnets}" ]
  security_groups    = [ var.security_group ]

  tags = {
    Name = "np-alb"
  }
}

# 타겟그룹 생성
resource "aws_lb_target_group" "this" {
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

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

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

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
