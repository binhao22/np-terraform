variable "region" {}

variable "vpc_cidr" {}

variable "sg_def" {}

variable "sg_ingress_pub" {}

variable "sg_ingress_pri" {}

variable "az" {
    type = list(string)
}

variable "public_subnets" {
    type = list(string)
}

variable "private_subnets" {
    type = list(string)
}