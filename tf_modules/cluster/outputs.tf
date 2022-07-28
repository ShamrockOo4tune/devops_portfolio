# For real life will use data discovery of AMI. Since the result is not free tier, will not use it here
# output "ami_found" {
#   value = data.aws_ami.image.image_id
# }

output "public_subnets_qty" {
  value = length(data.terraform_remote_state.network.outputs.public_subnets)
}
output "masters-subnets" {
  value = aws_instance.masters[*].subnet_id
}
output "workers-subnets" {
  value = aws_instance.workers[*].subnet_id
}
output "master_nodes_ip" {
  value = aws_instance.masters[*].public_ip
}
output "worker_nodes_ip" {
  value = aws_instance.workers[*].public_ip
}

