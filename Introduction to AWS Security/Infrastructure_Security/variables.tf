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