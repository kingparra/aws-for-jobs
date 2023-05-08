provider "aws" {
  shared_config_files = ["/home/chris/.aws/config"]
  shared_credentials_files = ["/home/chris/.aws/credentials"]
  region = "us-east-1"
  default_tags {
    tags = {
      ProjectName = "mount_efs_from_multiple_instances"
    }
  }
}

provider "random" {}

