terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }
}

locals {
  tags = {
    environment = "${var.environment}"
    tf_managed  = "true"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "infrastructure/dev/network/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "infrastructure/dev/network/terraform.tfstate"
    region = var.region
  }
}

data "aws_ami" "image" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
}

resource "aws_instance" "masters" {
  ami           = data.aws_ami.image.image_id
  instance_type = "t2.micro"
}
# output "ami_found" {
#   value = data.aws_ami.image.image_id
# }
