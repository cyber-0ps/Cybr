# Terraform configuration specifying required versions
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# AWS provider configuration using region from variables
provider "aws" {
  region = var.aws_region
}
