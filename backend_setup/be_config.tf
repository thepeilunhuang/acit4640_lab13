data "aws_region" "current" {
}    

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  # the following will prevent the bucket from being destroyed. In production
  # this is a good idea, but for this demo we want to be able to destroy the 
  # bucket
#  lifecycle {
#    prevent_destroy = true
#  }

  # the following will force the bucket to be destroyed when using terraform destroy
  # This isn't ideal for production
  force_destroy = true

}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "local_file" "tf_backend_config" {
  content = <<EOF
terraform {
    backend "s3" {
        bucket         = "${var.bucket_name}"
        key            = "terraform.tfstate"
        dynamodb_table = "${var.dynamodb_name}"
        region         =  "${data.aws_region.current.name}" 
        encrypt        = true
    }
}
EOF

  filename = "../infra/backend_config.tf"

}
