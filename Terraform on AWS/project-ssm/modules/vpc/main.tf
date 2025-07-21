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

# create an Internet Gateway for our VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "tf_igw"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = local.num_of_public_subnets
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.vpc_config.availability_zones[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 2, count.index +1) #function that automatically creates subnet CIDR blocks based n the VPC CIDR block
  tags = {
    "Name" = "tf_public_subnet_${count.index +1}"
  }  
}

# Create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw
  }
}

# Assocaite the route table with the public subnets
resource "aws_route_table_association" "public" {
  count = local.num_of_public_subnets 
  subnet_id = aws_subnet.public[count.index].id # gets each public subnet ID
  route_table_id = aws_route_table.public.id
}

# Private subnets and associated route tables
resource "aws_subnet" "private " {
  count = local.num_of_private_subnets
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.vpc_config.availability_zones[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index +1) #function that automatically creates subnet CIDR blocks based n the VPC CIDR block
  tags = {
    "Name" = "tf_private_subnet_${count.index +1}"
  }  
}

# Create route tables for each private subnet
resource "aws_route_table" "private" {
    count = local.num_of_private_subnets
    vpc_id = aws_vpc.vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }
}