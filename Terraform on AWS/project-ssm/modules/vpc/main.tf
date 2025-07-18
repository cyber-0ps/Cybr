# create local varibles to store the number of public and private subnets
locals {
  num_of_public_subnets = length(var.vpc_config.availability_zones)
  num_of_private_subnets = length(var.vpc_config.availability_zones)
}

# data source to get our current region
data "aws_region" "current" {}

# VPC
# create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  enable_dns_hostnames = var.vpc_config.enable_dns_hostnames
  enable_dns_support = var.vpc_config.enable_dns_support
  tags = var.vpc_config.tags
}