terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }

  backend "s3" {
    key = "infrastructure/infra/remote_state/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "remote_state" {
  source        = "../../../tf_modules/remote_state"
  bucket_name   = "portfolio-tf-state"
  dynamodb_name = "tf_locks"
}
