terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.54.0"
    }
  }
}

provider "random" {}

provider "aws" {
  profile = "default"
  region = "us-east-1"
  default_tags {tags = {AssignmentName = "setup_instance_to_grab_objects"}}
}
