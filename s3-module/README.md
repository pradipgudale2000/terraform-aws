# Terraform Module: S3 Bucket

This Terraform module creates an S3 bucket with configurable options.

## Usage

```hcl
module "s3_bucket_example" {
  source = "./"

  bucket_name       = "example-bucket"
  enable_versioning = true
}

