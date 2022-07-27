terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17.1"
    }
  }
}

data "aws_availability_zones" "availabe" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags       = local.tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.tags
}



#################
# Public subnets
#################

resource "aws_subnet" "public" {
  count                   = var.subnets_cardinality
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.availabe.names[count.index]
  tags = merge(
    local.tags,
    { type = "public" }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = merge(
    local.tags,
    { subnets_type = "public" }
  )
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}



#################
# Private subnets  only as example. NAT gateway is not covered with free tier
#################

/* resource "aws_subnet" "private" {
  count                   = var.subnets_cardinality
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.availabe.names[count.index]
  tags = merge(
    local.tags,
    { type = "private" }
  )
}

resource "aws_eip" "nat" {
  count = var.subnets_cardinality
  vpc   = true
  tags = merge(
    local.tags,
    { name = "${var.environment}-nat-gw-${count.index + 1}" }
  )
}

resource "aws_nat_gateway" "nat" {
  count         = var.subnets_cardinality
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  tags = merge(
    local.tags,
    { name = "${var.environment}-nat-gw-${count.index + 1}" }
  )
}

resource "aws_route_table" "private" {
  count  = var.subnets_cardinality
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = merge(
    local.tags,
    { subnets_type = "private" },
    { name = "${var.environment}-nat-gw-${count.index + 1}" }
  )
}

resource "aws_route_table_association" "private_route" {
  count          = length(aws_subnet.private[*].id)
  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = element(aws_subnet.private[*].id, count.index)
}
 */

locals {
  tags = {
    environment = "${var.environment}"
    tf_managed  = "true"
  }
}
