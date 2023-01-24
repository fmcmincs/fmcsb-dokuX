resource "aws_s3_bucket" "this" {
  bucket_prefix = var.bucket_name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}