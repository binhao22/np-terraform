output "vpc_id" {
  value = aws_vpc.this.id
}

# 모든 서브넷 id를 리스트에 담아 출력
output "private_subnets_ids" {
  value = flatten(["${aws_subnet.private.*.id}"])
}

output "public_subnets_ids" {
  value = flatten(["${aws_subnet.public.*.id}"])
}