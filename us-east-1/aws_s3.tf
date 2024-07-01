provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

resource "aws_s3_bucket" "pradip_bucket_3" {
  provider = aws.virginia
  bucket = "pradipgudlebucket3"
}

resource "aws_s3_bucket" "pradip_bucket_4" {
  bucket = "pradipgudlebucket4"
}
