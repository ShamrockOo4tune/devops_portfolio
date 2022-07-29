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
  count                  = var.masters_qty
  ami                    = var.ami
  instance_type          = var.master_instance_type
  vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.web-ssh_sg_id]
  key_name               = var.add_key_to_masters == true ? "nodes_key" : null
  subnet_id = element(
    data.terraform_remote_state.network.outputs.public_subnets[*],
    ceil(count.index / (var.masters_qty / length(data.terraform_remote_state.network.outputs.public_subnets)))
  )
  user_data                   = templatefile("user_data.tftpl", { public_key = file(var.public_key_path) })
  user_data_replace_on_change = true
  tags = merge(
    local.tags,
    { node_type = "master" }
  )
}

resource "aws_instance" "workers" {
  count                  = var.workers_qty
  ami                    = var.ami
  instance_type          = var.worker_instance_type
  vpc_security_group_ids = [data.terraform_remote_state.security_groups.outputs.web-ssh_sg_id]
  key_name               = var.add_key_to_workers == true ? "nodes_key" : null
  subnet_id = element(
    data.terraform_remote_state.network.outputs.public_subnets[*],
    ceil(count.index / (var.workers_qty / length(data.terraform_remote_state.network.outputs.public_subnets)))
  )
  user_data                   = templatefile("user_data.tftpl", { public_key = file(var.public_key_path) })
  user_data_replace_on_change = true
  tags = merge(
    local.tags,
    { node_type = "worker" }
  )
}

# TODO Better to be separate module. Better be separate keys
resource "aws_key_pair" "nodes_key" {
  count      = (var.add_key_to_masters == true) || (var.add_key_to_workers == true) ? 1 : 0
  key_name   = "nodes_key"
  public_key = file("${var.public_key_path}")
  tags       = local.tags
}
