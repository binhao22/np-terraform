# vpc module
module "vpc" {
  source          = "./vpc"

  vpc_cidr        = var.vpc_cidr
  az              = ["ap-northeast-2a", "ap-northeast-2c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
}

# sg module
module "sg" {
  source   = "./sg"

  for_each = var.sg_def
  sg_name  = each.value.sg_name
  vpc_id   = module.vpc.vpc_id
}

# sg-ingress module
module "sg-ingress-pub" {
  source     = "./sg-ingress"

  for_each   = var.sg_ingress_pub
  sg_id      = module.sg["pub"].id
  from_port  = each.value.from_port
  to_port    = each.value.to_port
  protocol   = each.value.protocol
  cidr_block = each.value.cidr_block  # null 허용
}

# sg-ingress module
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

# elb module
module "alb" {
  source          = "./elb"

  vpc_id          = module.vpc.vpc_id
  security_group  = module.sg["pub"].id
  subnets         = module.vpc.public_subnets_ids
}

# asg module
module "asg" {
  source     = "./asg"

  lb_tg = module.alb.lb_tg
  subnets = module.vpc.private_subnets_ids
  security_group  = module.sg["pri"].id
}