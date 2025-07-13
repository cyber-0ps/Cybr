terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.3.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  profile = "cybr"
}

resource "aws_s3_bucket" "example" {
  bucket = "kuljot-biring-test"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}