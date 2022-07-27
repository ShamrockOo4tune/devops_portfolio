variable "subnets_cardinality" {
  type        = number
  default     = 2
  description = "QTY of subnets of certain type (public / private) to create in the region. Each subnet goes to separate AZ"
  validation {
    condition     = (var.subnets_cardinality > 1) && (var.subnets_cardinality < 7)
    error_message = "Most of regions have 3 availablility zones. Some have more. Value should be > 1 and should not exceed qty of AZ available"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "environment" {
  type        = string
  description = "Environment for the resources to reside"
  validation {
    condition     = contains(["test", "infra", "dev", "stage", "prod"], var.environment)
    error_message = "Valid values are (test, infra, dev, stage, prod)"
  }
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}
