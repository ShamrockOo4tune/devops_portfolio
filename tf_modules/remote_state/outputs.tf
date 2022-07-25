output "remote_backend" {
  description = "s3 backend ARN"
  value       = aws_s3_bucket.tf-state.arn
}

output "tf_locks" {
  description = "Name of dynamodb used as lock table for tf"
  value       = aws_dynamodb_table.tf_locks.name
}

output "region" {
  description = "AWS region where the backend was deployed"
  value       = data.aws_region.current.name
}
