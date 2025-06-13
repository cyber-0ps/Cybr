# Create the VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "cybr-vpc-labs"
  }
}

# create an Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main

  tags = {
    Name = "cybr-igw"
  }
}

