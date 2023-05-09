terraform {
  cloud {
    organization = "aws-for-jobs"
    workspaces {
      name = "review_megalab"
    }
  }
}
