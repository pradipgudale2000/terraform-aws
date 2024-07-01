provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  
  # Enable versioning if specified
  versioning {
    enabled = var.enable_versioning
  }

  # Additional configurations (e.g., ACLs, encryption) can be added here

  tags = {
    Name = var.bucket_name
    // Add more tags as needed
  }
}

# Optionally, add data classification configurations or other features

