output "web-ssh_sg_id" {
  value       = aws_security_group.web-ssh.id
  description = "ID of the VPC to be consumed by other modules"
}
