variable "bucket_name" {
  description = "Prefix for your S3 bucket"
  type        = string
}

variable "bucket_versioning_enabled" {
  description = "Enables versioning"
  type        = bool
  default     = true
}

variable "key_arn" {
  description = "KMS Key ARN"
  type        = string
  default     = true
}