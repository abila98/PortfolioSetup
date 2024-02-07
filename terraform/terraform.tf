#terraform {
#  required_version = ">= 1.0"
#}


provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "kohee-terraform-state"
    key            = "state.tfstate"
    dynamodb_table = "kohee-terraform-state-lock"
    encrypt        = true
  }
}

