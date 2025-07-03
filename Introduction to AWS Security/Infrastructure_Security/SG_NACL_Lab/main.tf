# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "cybr-lab"
  }
}

# Security Groups: Web Servers
resource "aws_security_group" "web_servers" {
  name        = var.web_sg_name
  description = "Allow HTT and HTTP from anywhere"
  vpc_id      = aws_vpc.main

  # allow port 80 ingress
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # redundant but useful for update later (since it allows all outbound protocols - however you may want to restrict this)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.web_sg_name
  }
}

# Security Group: App Servers
resource "aws_security_group" "app_servers" {
  name = var.app_sg_name
  description = "Allow traffic from web servers"
  vpc_id = aws_vpc.main.id
  
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_groups = [aws_security_group.web_servers.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group: IT Administration
resource "aws_security_group" "it_admin" {
  name = var.it_sg_name
  description = "Allow SSH and RDP from IT admin IPs"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group: Database
resource "aws_security_group" "database" {
  name = var.db_sg_name
  description = "Allow MySQL access from app servers"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = [aws_security_group.app_servers]
  }
}