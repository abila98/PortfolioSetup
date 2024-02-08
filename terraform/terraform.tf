terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }

  required_version = ">= 1.1"
}

provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    region         = "us-west-1"
    bucket         = "portfolio-terraform-s3-bucket"
    key            = "state.tfstate"
    dynamodb_table = "portfolio-terraform-state-lock"
    encrypt        = true
  }
}


