# vpc module
module "vpc" {
  source          = "./vpc"

  vpc_cidr        = var.vpc_cidr
  az              = var.az
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
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

  cidr_block = each.value.cidr_block
}

# sg-ingress module
module "sg-ingress-pri" {
  source    = "./sg-ingress"

  for_each  = var.sg_ingress_pri
  sg_id     = module.sg["pri"].id
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol
  
  # 퍼블릭 sg 소스 허용
  source_sg = module.sg["pub"].id
}

# elb module
module "alb" {
  source          = "./elb"

  vpc_id          = module.vpc.vpc_id
  security_group  = module.sg["pub"].id
  subnets         = module.vpc.public_subnets_ids
  lb_type         = "application"
  internal        = false
  tg_port         = 80
  tg_protocol     = "HTTP"
}

# asg module
module "asg" {
  source            = "./asg"

  lb_tg             = module.alb.lb_tg
  subnets           = module.vpc.private_subnets_ids
  security_group    = module.sg["pri"].id
  health_check_type = "ELB"
  min_size          = 1
  max_size          = 2
  ami               = "ami-0c031a79ffb01a803"  # Amazon Linux 2023
  instance_type     = "t2.micro"
}