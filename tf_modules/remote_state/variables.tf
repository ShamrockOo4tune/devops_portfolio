variable "bucket_name" {
  description = "The name for the remote backkend (s3 bucket)"
  type        = string
}

variable "dynamodb_name" {
  description = "The name of the dynamodb for tf locks"
  type        = string
}
