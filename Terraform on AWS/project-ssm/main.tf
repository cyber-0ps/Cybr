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

# Get current region
data "aws_region" "current" {
  
}