output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_1_id" {
  value = aws_subnet.private_1.id
}

output "private_subnet_2_id" {
  value = aws_subnet.private_2.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}

output "nat_eip_allocation_id" {
  value = aws_eip.nat.id
}