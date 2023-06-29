terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # default_tags {
  #   tags = {
  #     Lab = "mod13lab1"
  #   }
  # }
}
