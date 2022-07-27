terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }

  backend "s3" {
    key     = "infrastructure/stage/security_groups/terraform.tfstate"
    encrypt = true
    # Provide remainig params explicitly:
    # region         = "eu-central-1"
    # bucket         = "portfolio-tf-state"
    # dynamodb_table = "tf_locks"
    # OR init with -backend-config argument:
    # $ terraform init -backend-config=<repo_root_path>/phase_1/backend.hcl
    # backend.hcl can be generated with <repo_root_path>/phase_1/setup.sh
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "security_groups" {
  source      = "../../../tf_modules/security_groups"
  environment = "stage"
  bucket      = var.bucket
  region      = var.region
  # Overridable defaults:
  # web-ssh_ports = [80, 443, 22]
}
