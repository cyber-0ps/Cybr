provider "aws" {
  region  = "us-east-1"
  profile = "cybr"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "kjsverycools3bucket2025"
}