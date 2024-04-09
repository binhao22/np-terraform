############## ALL ###############
##################################
region = "ap-northeast-2"
vpc_cidr = "10.0.0.0/16"


############## VPC ###############
##################################
az              = ["ap-northeast-2a", "ap-northeast-2c"]
public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]


############### SG ###############
##################################
sg_def = {
    pub = {
        sg_name = "np-sg-pub"
    },
    pri = {
        sg_name = "np-sg-pri"
    }
}

sg_ingress_pub = {
    http = {
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
    }
    https = {
        from_port  = 443
        to_port    = 443
        protocol   = "tcp"
        cidr_block = "0.0.0.0/0"
    }
    ssh = {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_block = "0.0.0.0/0"
    }
}

sg_ingress_pri = {
    http = {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
    }
    https = {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"
    }
    ssh = {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
    }
}
