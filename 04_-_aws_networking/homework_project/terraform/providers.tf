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
  shared_config_files = ["/home/chris/.aws/config"]
  shared_credentials_files = ["/home/chris/.aws/credentials"]
  profile = "default"
  region = "us-east-1"
  default_tags {
    tags = {
      AssignmentName = "mod_4_homework_project"
      # SessionName = random_pet.session_name.id
    }
  }
}

provider "random" {}

provider "tls" {}
