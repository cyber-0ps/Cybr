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
  for_each            = toset(var.vpc_endpoints) # Create a VPC endpoint for each service in the var.vpc_endpoints list
  vpc_id              = module.networking.vpc_resources.vpc_id
  subnet_ids          = module.networking.vpc_resources.private_subnet_ids
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true # Allow services within the VPC to automatically use the endpoint
  security_group_ids  = [aws_security_group.vpce_security_groups.id]

  tags = {
    "Name" = "tf_vpc_endpoint_${each.key}"
  }
}

# Create VPC endpoint SG and associated rules
resource "aws_security_group" "vpce_security_groups" {
  vpc_id      = module.networking.vpc_resources.id
  name        = "VPC Endpoiits for SSM"
  description = "Allos inbound HTTPS traffic to the VPC Endpoints"
}

resource "aws_security_group_rule" "vpce_ingress_itself" {
  type                     = "ingress"
  description              = "Allows HTTPS traffic from itself"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce_security_groups.id # the security groups to attach
  source_security_group_id = aws_security_group.vpce_security_groups.id # originating traffice form the same security group
}

resource "aws_security_group_rule" "vpc_ingress_ec2" {
  type                     = "ingress"
  description              = "Allows HTTPS traffic from EC2 instances"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce_security_groups.id
  source_security_group_id = aws_security_group.ssm_ec2.id
}

# Create EC2s
module "ec2_public1" {
  source = "./modules/ec2"

  ec2_config = {
    instance_type   = "t2.micro"
    subnet_id       = module.networking.vpc_resources.public_subnet_ids[0]
    public_ip       = true
    security_groups = [aws_security_group.ssm_ec2.id]

    tags = {
      "Namee" = "tf_ec2_public1"
    }
  }
}

module "ec2_private1" {
  source = "./modules/ec2"

  ec2_config = {
    instance_type   = "t2.micro"
    subnet_id       = module.networking.vpc_resources.private_subnet_ids[0]
    security_groups = [aws_security_group.ssm_ec2.id]

    tags = {
      "Namee" = "tf_ec2_private1"
    }
  }
}

# Create EC2 security group and associated rules
resource "aws_security_group" "ssm_ec2" {
  vpc_id      = module.networking.vpc_resources.vpc_id
  name        = "Allow SSM for EC2"
  description = "Allows EC2 HTTP traffic to the SSM VPC Endpoints"
}

resource "aws_security_group_rule" "ssm_ec2" {
  type                     = "egress"
  description              = "Allows EC2 HTTP traffic to the SSM VPC endpoint SG"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ssm_ec2.id
  source_security_group_id = aws_security_group.vpce_security_groups.id
}