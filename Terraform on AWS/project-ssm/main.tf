# Get current region
data "aws_region" "current" {}

# Create VPC Network
module "networking" {
  source = "./modules/vpc"

  vpc_config = {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    availability_zones   = ["us-east-1a", "us-east-1b"]

    tags = {
      "Name" = "tf_vpc_1"
    }
  }
}

# Enable SSM
module "ssm" {
  source = "./modules/ssm"
}

# Create VPC Endpoints
resource "aws_vpc_endpoint" "vpc_endpoints" {
  for_each = toset(var.vpc_endpoints) # Create a VPC endpoint for each service in the var.vpc_endpoints list
  vpc_id = module.networking.vpc_resources.vpc_id
  subnet_ids = module.networking.vpc_resources.private_subnet_ids
  service_name = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true # Allow services within the VPC to automatically use the endpoint
  security_group_ids = [aws_security_group.vpce_security_groups.id]

  tags = {
    "Name" = "tf_vpc_endpoint_${each.key}"
  }
}

# Create VPC endpoint SG and associated rules
resource "aws_security_group" "vpce_security_groups" {
  vpc_id = module.networking.vpc_resources.id
  name = "VPC Endpoiits for SSM"
  description = "Allos inbound HTTPS traffic to the VPC Endpoints"
}

