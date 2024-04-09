# VPC module
module "vpc" {
  source          = "./vpc"

  vpc_cidr        = var.vpc_cidr
  az              = ["a", "c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
}

# SG module
module "sg" {
  source   = "./sg"

  for_each = var.sg_def
  sg_name  = each.value.sg_name
  vpc_id   = var.vpc_cidr
}

# SG-pub inbound rule
module "sg-ingress-pub" {
  source     = "./sg-ingress"

  for_each   = var.sg_ingress_pub
  sg_id      = module.sg["pub"].id
  from_port  = each.value.from_port
  to_port    = each.value.to_port
  protocol   = each.value.protocol
  cidr_block = [each.value.cidr_block]  # null 허용
}

# SG-pri inbound rule
module "sg-ingress-pri" {
  source    = "./sg-ingress"

  for_each  = var.sg_ingress_pri
  sg_id     = module.sg["pri"].id
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol
  
  # 퍼블릭 보안그룹 트래픽만 허용
  source_sg = module.sg["pub"].id  # null 허용
}