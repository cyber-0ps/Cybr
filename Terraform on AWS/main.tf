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
  alias = "ue1"
  profile = "cybr"
}

provider "aws" {
  # Configuration options
  region = "eu-west-1"
  alias = "ew1"
  profile = "cybr"
}

resource "aws_s3_bucket" "example" {
  bucket = "kuljot-biring-test-useast1"
  provider = aws.ue1

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "example2" {
  bucket = "kuljot-biring-test-bucket-euwest1"
  provider = aws.ew1

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}