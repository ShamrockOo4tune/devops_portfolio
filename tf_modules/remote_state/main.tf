terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }
}

resource "aws_s3_bucket" "tf-state" {
  bucket = var.bucket_name
  lifecycle {
    #prevent_destroy = true
  }

  tags = {
    name        = "tf_state"
    environment = "shared"
    tf_managed  = true
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.tf-state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tf-state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    name        = "tf_locks"
    environment = "shared"
    tf_managed  = true
  }
}

data "aws_region" "current" {
}
