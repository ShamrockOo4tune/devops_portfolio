variable "bucket" {
  description = "The name of the backend (remote state) s3 bucket"
  type        = string
}

variable "region" {
  description = "The region of the backend (remote state) s3 bucket"
  type        = string
}

variable "environment" {
  type        = string
  description = "Environment for the resources to reside"
  validation {
    condition     = contains(["test", "infra", "dev", "stage", "prod"], var.environment)
    error_message = "Valid values are (test, infra, dev, stage, prod)"
  }
}

variable "master_instance_type" {
  type        = string
  description = "type of AWS EC2 instance - master node"
  default     = "t2.micro"
}

variable "worker_instance_type" {
  type        = string
  description = "type of AWS EC2 instance - worker node"
  default     = "t2.micro"
}

variable "ami" {
  type        = string
  description = "AWS AMI"
  default     = "ami-094c442a8e9a67935" # for eu-central-1, Amazon linux, kernel 4.14, 64-x86
}

variable "masters_qty" {
  type        = number
  default     = 1
  description = "Qty of master instances to create"
}

variable "workers_qty" {
  type        = number
  default     = 3
  description = "Qty of worker instances to create"
}

variable "public_key_path" {
  type        = string
  default     = "../../../phase_1/nodes_key.pub"
  description = "Path to public ssh key which is going to be used for remote access to EC2 the nodes"
}

variable "add_key_to_masters" {
  type        = bool
  default     = false
  description = "Will master nodes need default user remote access (with certificate) enabled?"
}

variable "add_key_to_workers" {
  type        = bool
  default     = false
  description = "Will worker nodes need default user remote access (with certificate) enabled?"
}
