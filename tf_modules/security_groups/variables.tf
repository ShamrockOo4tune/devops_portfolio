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

variable "web-ssh_ports" {
  type        = list(number)
  description = "Allow inbound traffic on this ports"
  default     = [80, 443, 22]
}
