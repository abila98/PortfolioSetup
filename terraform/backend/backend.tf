# Create an S3 bucket for storing Terraform state
resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "portfolio-terraform-s3-bucket-v1"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = "portfolio-s3"
  }
}

# Configure server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_bucket_sse" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Specify the encryption algorithm (e.g., AES256)
    }
    bucket_key_enabled = true
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "S3_with_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "remotestate_table" {
  name         = "portfolio-terraform-state-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "portfolio-dynamodb"
  }
}
