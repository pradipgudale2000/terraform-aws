provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucket_name
  #acl    = var.acl

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "pradip_bucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "private"
}

