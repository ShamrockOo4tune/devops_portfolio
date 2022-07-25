output "backend_s3_ARN" {
  value       = module.remote_state.remote_backend
  description = "s3 backend ARN"
}

output "backend_dynamodb_name" {
  value       = module.remote_state.tf_locks
  description = "dynamodb backend name"
}

output "region" {
  value       = module.remote_state.region
  description = "AWS region where the backend was deployed"
}
