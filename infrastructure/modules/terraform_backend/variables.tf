# Bucket name
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to store Terraform state files"
}

# Whether to force destroy the bucket, including all objects
variable "force_destroy" {
  type        = bool
  default     = false
  description = "Whether to force destroy the bucket, including all objects"
}

# Environment name (tag purpose)
variable "environment" {
  type        = string
  description = "Environment for the Terraform state bucket (e.g., lab, dev, prod)"
}

# Additional tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to the S3 bucket"
}
