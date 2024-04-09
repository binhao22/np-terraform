variable "sg_id" {}

variable "from_port" {}

variable "to_port" {}

variable "protocol" {}

variable "cidr_block" {
    default = ""
}

variable "source_sg" {
    default = ""
}