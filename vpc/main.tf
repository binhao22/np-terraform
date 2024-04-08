# VPC 생성
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "np-vpc"
  }
}

# NACL 생성
resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  subnet_ids = flatten([
    "${aws_subnet.public.*.id}",
    "${aws_subnet.private.*.id}",
  ])

  tags = {
    Name = "np-nacl"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  count = "${length(var.public_subnets)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${var.az[count.index]}"
 
  tags = {
    Name = "np-pub-sub"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  count = "${length(var.private_subnets)}"
  vpc_id            = "${aws_vpc.this.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${var.az[count.index]}"
 
  tags = {
    Name = "np-pri-sub"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "np-igw"
  }
}

# 고정 IP 생성
resource"aws_eip" "this" {
    count = "${length(var.az)}"
    vpc = true
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "this" {
  count = "${length(var.az)}"
  allocation_id = "${aws_eip.this.*.id[count.index]}"
  subnet_id     = "${aws_subnet.public.*.id[count.index]}"
}

# 퍼블릭 라우팅 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  # 외부 트래픽, 인터넷 게이트웨이 지정
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  # 내부 트래픽, 로컬
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "np-rtb-pub"
  }
}

# 프라이빗 라우팅 테이블 생성
resource "aws_route_table" "private" {
  count = "${length(var.az)}"
  vpc_id = aws_vpc.this.id

  # 외부 트래픽, NAT 게이트웨이 지정
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.this.*.id[count.index]}"
  }
  # 내부 트래픽, 로컬
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  tags = {
    Name = "np-rtb-pri"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(var.public_subnets)}"
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count = "${length(var.private_subnets)}"
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_route_table.private.*.id[count.index]}"
}
