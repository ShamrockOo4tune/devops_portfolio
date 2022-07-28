output "public_subnets_qty" {
  value = module.cluster.public_subnets_qty
}
output "masters-subnets" {
  value = module.cluster.masters-subnets
}
output "workers-subnets" {
  value = module.cluster.workers-subnets
}
output "master_nodes_ip" {
  value = module.cluster.master_nodes_ip
}
output "worker_nodes_ip" {
  value = module.cluster.worker_nodes_ip
}
