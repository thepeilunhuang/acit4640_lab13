output "vpc_id" {
  value = aws_vpc.vpc_1.id
}

output "sn_1_id" {
  value = aws_subnet.sn_1.id

}

output "gw_1_id" {
  value = aws_internet_gateway.gw_1.id
}

output "rt_1_id" {
  value = aws_route_table.rt_1.id
}
