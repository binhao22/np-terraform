# 보안그룹 생성
resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.sg_name
  }
}

# 아웃바운드 규칙 생성
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}