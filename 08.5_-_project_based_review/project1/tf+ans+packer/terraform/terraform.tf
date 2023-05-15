terraform {
  required_version = "1.4.6"
  cloud {
    organization = "aws-for-jobs"
    workspaces {
      name = "review_project_1"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}
