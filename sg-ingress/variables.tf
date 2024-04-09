variable "sg_id" {}

variable "from_port" {}

variable "to_port" {}

variable "protocol" {}

# 참조값이 비어있을 수 있음
variable "cidr_block" {
    default = ""
}

variable "source_sg" {
    default = ""
}