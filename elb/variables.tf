variable "vpc_id" {}

variable "security_group" {}

variable "subnets" {
    type = list(string)
}