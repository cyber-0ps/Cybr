// Custom VPC
resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = var.aws_tagging
}

// Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  filtered_azs = [for az in data.aws_availability_zones.available.names : az if contains(var.desired_azs, az)]
}

// Subnet within the VPC
resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = element(local.filtered_azs, 0)

  tags = var.aws_tagging
}