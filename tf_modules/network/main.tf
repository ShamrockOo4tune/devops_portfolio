terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }
}

data "aws_availability_zones" "availabe" {}


resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name        = "vpc_dev"
    environment = "dev"
    tf_managed  = true
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.dev.id
  tags = {
    environment = "dev"
    tf_managed  = true
  }
}

resource "aws_subnet" "public" {
  count                   = var.subnets_cardinality
  vpc_id                  = aws_vpc.dev.id
  map_public_ip_on_launch = true
  cidr_block              = element(["10.0.1.0/24", "10.0.2.0/24"], count.index)
  availability_zone       = data.aws_availability_zones.availabe.names[count.index]
  tags = {
    environment = "dev"
    tf_managed  = true
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    name        = "public_subnet_route_table"
    environment = "dev"
    tf_managed  = true
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public_subnets.id
}

variable "subnets_cardinality" {
  type        = number
  default     = 2
  description = "QTY of subnets of certain type (public / private) to create in the region. Each subnet goes to separate AZ"
  validation {
    condition     = (var.subnets_cardinality > 1) && (var.subnets_cardinality < 5)
    error_message = "Most of regions have 3 availablility zones. Some have more. Value should be > 1 and should not exceed qty of AZ available"
  }
}
