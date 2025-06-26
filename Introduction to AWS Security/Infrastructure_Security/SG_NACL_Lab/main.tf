# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "cybr-lab"
  }
}

# Security Groups: Web Servers
resource "aws_security_group" "web_servers" {
  name = var.web_sg_name
  description = "Allow HTT and HTTP from anywhere"
  vpc_id = aws_vpc.main

  # allow port 80 ingress
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}