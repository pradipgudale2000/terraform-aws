variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "The bucket name must be between 3 and 63 characters."
  }
}

#variable "acl" {
#  description = "The ACL to apply to the S3 bucket"
#  type        = string
  #default     = "private"
#  validation {
#    condition     = contains(["private", "public-read", "public-read-write", "authenticated-read"], var.acl)
#    error_message = "The ACL must be one of 'private', 'public-read', 'public-read-write', or 'authenticated-read'."
#  }
#}

variable "region" {
  description = "The AWS region where the S3 bucket will be created. (us-east-1,us-east-2)"
  type        = string
  #default     = "us-east-1"
}

