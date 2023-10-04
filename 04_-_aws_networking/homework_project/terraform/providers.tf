terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.54.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}


provider "aws" {
  default_tags {
    tags = {
      AssignmentName = "mod_4_homework_project"
    }
  }
}

provider "random" {}

provider "tls" {}
