output "web-ssh_sg_id" {
  value       = module.security_groups.web-ssh_sg_id
  description = "ID of the VPC to be consumed by other modules"
}
