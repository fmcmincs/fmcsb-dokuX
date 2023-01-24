/* 
# key is self contained within the s3 module
resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
*/

# creates bucket server side encryption via the beforehand created kms key
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}