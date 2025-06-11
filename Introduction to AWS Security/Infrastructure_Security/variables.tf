# AWS region to deploy the infrastructure
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type = string
  default = "us-east-1"
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

# Public subnet CIDRs (2 subnets in 2 different AZs)
variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private subnet CIDRs (2 subnets in 2 different AZs)
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}