output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "IDs of public subnets (bastion, NAT, internet-facing ALB)"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets (EKS nodes and pods)"
  value       = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "nat_public_ip" {
  description = "Public IP of the NAT Gateway — whitelist this on external services"
  value       = aws_eip.nat.public_ip
}
