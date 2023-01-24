locals {
  vpc_count = 3
}

# ------------------- LOCAL MODULES -------------------
# -----------------------------------------------------
module "kms" {
  source                  = "../../modules/kms"
  description             = "Key for S3-Bucket"
  deletion_window_in_days = 10
}

# refer to output -> if kms key should be placed within composition refer to -> module.kms.key_arn

module "s3_bucket" {
  source                    = "../../modules/s3"
  bucket_name               = var.bucket_name
  bucket_versioning_enabled = true
  key_arn                   = module.kms.key_arn
}




# ------------------- REMOTE  MODULES -------------------
# -------------------------------------------------------


# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
  count = local.vpc_count
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc-count-${count.index}"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_tls" {
  for_each = {for k in range(local.vpc_count): k=>k}
  name        = "allow_tls_count_${each.value}"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc[each.value].vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["${module.vpc[each.value].vpc_cidr_block}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

# Fetch instance image
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
#resource "aws_instance" "name" {
  
#}

