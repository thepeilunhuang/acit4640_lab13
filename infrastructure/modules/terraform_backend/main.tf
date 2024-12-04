
resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy

  tags = merge(
    {
      Name        = var.bucket_name
      Environment = var.environment
    },
    var.tags
  )
}


resource "aws_s3_bucket_acl" "terraform_state_acl" {
  bucket = aws_s3_bucket.terraform_state.id
  acl    = "private"
}


resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
