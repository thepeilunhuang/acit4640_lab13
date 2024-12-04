# output bucket name
output "bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "The name of the S3 bucket storing the Terraform state files"
}

# output bucket arn
output "bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket storing the Terraform state files"
}
