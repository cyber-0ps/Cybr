resource "aws_s3_bucket" "example" {
  bucket = "kuljot-biring-test"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}