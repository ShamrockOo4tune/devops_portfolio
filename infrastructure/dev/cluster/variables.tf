variable "bucket" {
  description = "The name of the backend (remote state) s3 bucket"
  type        = string
}

variable "region" {
  description = "The region of the backend (remote state) s3 bucket"
  type        = string
}

variable "dynamodb_table" {
  description = "ignore me"
  type        = string
  default     = ""
}
