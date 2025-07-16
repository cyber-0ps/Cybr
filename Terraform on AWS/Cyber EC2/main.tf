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

// Security group
resource "aws_security_group" "example" {
  name        = "Example Security Group"
  description = "Example security group for EC2 instance"
  vpc_id      = aws_vpc.custom_vpc.id

  tags = var.aws_tagging
}

// Ingress rule
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = aws_vpc.custom_vpc.cidr_block
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
}

// Egress rule
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.example.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}