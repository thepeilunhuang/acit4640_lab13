# VPC ID
output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC"
}

# VPC CIDR Block
output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "The CIDR block of the VPC"
}

# public subnet ids
output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "A list of IDs for the public subnets"
}

# private subnet ids
output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "A list of IDs for the private subnets"
}

# Internet Gateway ID
output "internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway"
}
