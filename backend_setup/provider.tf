terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.1"
    }

  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-west-2"
}