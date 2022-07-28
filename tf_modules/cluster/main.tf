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
    key    = "infrastructure/dev/security_groups/terraform.tfstate"
    region = var.region
  }
}

# for real projects need to pick up AMI depending on the region
# for the simplicity and cost reduction, only free tier AMI will be used
# provided explicitly as the input variable
# data "aws_ami" "image" {
#   owners      = ["amazon"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
#   }
# }

resource "aws_instance" "masters" {
  count           = var.masters_qty
  ami             = var.ami
  instance_type   = var.master_instance_type
  security_groups = [data.terraform_remote_state.security_groups.outputs.web-ssh_sg_id]

  # TODO need a solution to distribute instances evenly among available subnets 
  # when subnets cardinality > 2
  subnet_id = (count.index + 1 <= var.masters_qty / 2 ?
    element(data.terraform_remote_state.network.outputs.public_subnets[*], 1) :
    element(data.terraform_remote_state.network.outputs.public_subnets[*], 2)
  )
}

resource "aws_instance" "workers" {
  count           = var.workers_qty
  ami             = var.ami
  instance_type   = var.worker_instance_type
  security_groups = [data.terraform_remote_state.security_groups.outputs.web-ssh_sg_id]

  # TODO need a solution to distribute instances evenly among available subnets 
  # when subnets cardinality > 2
  subnet_id = (count.index + 1 <= var.workers_qty / 2 ?
    element(data.terraform_remote_state.network.outputs.public_subnets[*], 1) :
    element(data.terraform_remote_state.network.outputs.public_subnets[*], 2)
  )
}
