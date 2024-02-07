resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = "kohee-terraform-state" 
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "kohee-s3"
  }
} 




resource "aws_dynamodb_table" "remotestate_table" {
  name           = "kohee-terraform-state-lock"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "kohee-Dynamo"
  }

}
