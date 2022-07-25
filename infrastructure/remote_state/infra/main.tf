provider "aws" {
  region = var.region
}

module "remote_state" {
  source        = "../../../tf_modules/remote_state"
  bucket_name   = var.bucket_name
  dynamodb_name = var.dynamodb_name
}
