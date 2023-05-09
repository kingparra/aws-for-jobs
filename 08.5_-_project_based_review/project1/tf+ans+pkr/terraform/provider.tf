provider "aws" {
  region = "us-east-1"
  # This provider reads creds from ~/.aws/credentials by default.
  # Another (new) option is to define a *variable set* in HCP. This is similar to defining a vars file, not committing it to git, and then storing it on an encrypted remote backend.
  default_tags {
    tags = {
      ProjectName = "mod8.5_mega_review_lab"
    }
  }
}
