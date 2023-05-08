terraform {
  required_version = "1.4.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      ProjectName = "mod8_project1"
    }
  }
}
