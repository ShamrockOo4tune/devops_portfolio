provider "aws" {
  region = "eu-central-1"
}

module "network" {
  source = "../../../tf_modules/network"
}
