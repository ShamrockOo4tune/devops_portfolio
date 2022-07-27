terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }

  backend "s3" {
    key     = "infrastructure/dev/cluster/terraform.tfstate"
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

module "cluster" {
  source      = "../../../tf_modules/cluster"
  environment = "dev"
  bucket      = var.bucket
  region      = var.region
  # Overridable defaults:
  # 
}

output "ami_found" {
  value = module.cluster.ami_found
}
