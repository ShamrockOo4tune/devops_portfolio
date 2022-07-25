variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "bucket_name" {
  default     = "portfolio-tf-state"
  description = "The name for the remote backkend (s3 bucket)"
}

variable "dynamodb_name" {
  description = "The name of the dynamodb for tf locks"
  default     = "tf_locks"
}
