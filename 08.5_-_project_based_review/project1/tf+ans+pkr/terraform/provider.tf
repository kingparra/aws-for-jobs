provider "aws" {
  # These variables are defined in a *variable set* in HCP.
  # This is like defining a vars file,
  # not committing it to git, and then storing
  # it on an encrypted remote backend.
  region = "us-east-1"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  default_tags {
    tags = {
      ProjectType = "Terraform"
      Client = "Energym"
    }
  }
}
