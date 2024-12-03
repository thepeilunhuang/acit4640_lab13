variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "dynamodb_name" {
    description = "DynamoDB table name"
    type        = string
}

data "aws_region" "aws_current_region" {}