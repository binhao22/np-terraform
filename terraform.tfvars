############## ALL ###############
##################################
region = "ap-northeast-2"

############### SG ###############
##################################
sg_def = {
    pub = {
        name = "np-sg-pub"
    },
    pri = {
        name = "np-sg-pri"
    }
}

sg_ingress_pub = {
    http = {
        from_port  = 80
        to_port    = 80
        protocol   = "tcp"
        cidr_block = [ "0.0.0.0/0" ]
    }
    https = {
        from_port  = 443
        to_port    = 443
        protocol   = "tcp"
        cidr_block = [ "0.0.0.0/0" ]
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
}
