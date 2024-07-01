# Terraform S3 Bucket Module

This module creates an S3 bucket with configurable settings.

## Inputs

- `bucket_name`: The name of the S3 bucket (required, string, must be between 3 and 63 characters).
- `acl`: The ACL to apply to the S3 bucket (optional, string, default: `private`, must be one of `private`, `public-read`, `public-read-write`, `authenticated-read`).
- `region`: The AWS region where the S3 bucket will be created (optional, string, default: `us-east-1`).

## Outputs

- `bucket_name`: The name of the S3 bucket.

## Example Usage

```hcl
module "s3_bucket" {
  source      = "./path/to/terraform-s3-bucket"
  bucket_name = "my-unique-bucket-name"
  acl         = "private"
  region      = "us-east-1"
}

output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

