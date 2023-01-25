output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "instance_ids" {
  description = "IDs of EC2 instances"
  value = aws_instance.app_server_23.*.id
}