import {
  to = aws_s3_bucket.bucket_to_import
  id = "demo-import-bucket"
}

resource "aws_s3_bucket" "bucket_to_import" {
    bucket = "demo-import-bucket"
    force_destroy = true
}