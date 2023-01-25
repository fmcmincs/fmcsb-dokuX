variable "number" {
  type = string
  description = "111111111111"
}

variable "region" {
  type        = string
  description = "eu-west-1"
}

variable "profile" {
  type        = string
  description = "fmcsbtestcs"
}

variable "bucket_name" {
  type        = string
  description = "fairmar${var.profile}bucket${var.number}"
}
