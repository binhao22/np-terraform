# 세부적인 트래픽 보안 설정을 위해, 인바운드 규칙을 별도의 모듈로 구현

# cidr 기반 인바운드 규칙
resource "aws_security_group_rule" "inbound-cidr" {
  # source_sg 변수에 값이 있을 때, cidr 기반 규칙 생성
  count             = 1 - var.source_sg

  security_group_id = var.sg_id
  type              = "ingress"
  from_port         = var.from_port
  to_port           = var.to_port
  protocol          = var.protocol
  cidr_blocks       = var.cidr_block
}

# sg 기반 인바운드 규칙
resource "aws_security_group_rule" "inbound-sg" {
  # cidr_block 변수에 값이 있을 때, cidr 기반 규칙 생성
  count                    = 1 - var.cidr_block

  security_group_id        = var.sg_id
  type                     = "ingress"
  from_port                = var.from_port
  to_port                  = var.to_port
  protocol                 = var.protocol
  source_security_group_id = var.source_sg
}