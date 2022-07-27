output "backend_bucket_name" {
  description = "s3 backend ARN"
  value       = aws_s3_bucket.tf-state.bucket
}

output "backend_dynamodb_name" {
  description = "Name of dynamodb used as lock table for tf"
  value       = aws_dynamodb_table.tf_locks.name
}

output "backend_region_name" {
  description = "AWS region where the backend was deployed"
  value       = data.aws_region.current.name
}
