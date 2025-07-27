resource "aws_s3_bucket" "example" {
  bucket = var.aws_s3_bucket_name

  tags = var.aws_tagging
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}