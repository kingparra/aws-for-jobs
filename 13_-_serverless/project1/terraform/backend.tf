terraform {
  backend "s3" {
     region = "us-east-1"
     bucket = "terraform-backend-mod13-project1"
     key = "terraform.tfstate"
     encrypt = true
  }
}

module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  version = "1.1.1"
  name = "terraform-backend-mod13-project1"
  force_destroy = false
}
