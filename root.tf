# VPC module
module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  az = ["a", "c"]
  public_subnets = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]
}