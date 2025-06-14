# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
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

# public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "cybr-public-subnet-${count.index + 1}"
  }
}

# route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "cybr-public-rt"
  }
}

# associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# private subnets
resource "aws_subnet" "private" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.vpc_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "cybr-private-subnet-${count.index + 1}"
  }
}

# route tables for private subnet for S3 endpoint
resource "aws_route_table" "private" {
  count = 2
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "cybr-private-rt-${count.index + 1}"
  }
}
