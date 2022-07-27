terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }

  backend "s3" {
    key     = "infrastructure/dev/network/terraform.tfstate"
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

module "network" {
  source      = "../../../tf_modules/network"
  environment = "dev"
  # overridable defaults: 
  # subnets_cardinality = 2
  # vpc_cidr            = "10.0.0.0/16"
  # public_subnet_cidrs = ["10.0.1.0/24", ... , "10.0.6.0/24"]
}
