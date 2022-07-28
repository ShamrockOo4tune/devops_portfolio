output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC to be consumed by other modules"
}

output "public_subnets" {
  value       = aws_subnet.public[*].id
  description = "list of public subnet ID "
}

output "private_subnets" {
  value       = aws_subnet.private[*].id
  description = "list of public subnet ID "
}
