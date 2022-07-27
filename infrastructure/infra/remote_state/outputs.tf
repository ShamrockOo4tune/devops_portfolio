output "bucket" {
  value = module.remote_state.backend_bucket_name
}

output "dynamodb_table" {
  value = module.remote_state.backend_dynamodb_name
}

output "region" {
  value = module.remote_state.backend_region_name
}
