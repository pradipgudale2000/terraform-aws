provider "aws" {
  region = var.region
  access_key = "AKIA4ICCZNY7T2G2OQ7I"
  secret_key = "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"
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

