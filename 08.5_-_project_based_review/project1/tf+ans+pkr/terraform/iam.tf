data "aws_iam_roles" "S3full" {
  name_regex = "^AmazonS3FullAccess$"
}

resource "aws_iam_role_policy_attachment" "S3fullAttachment" {
  role = aws_iam_role.EnergymInstanceProfileRole.name
  policy_arn = data.aws_iam_roles.S3full.arns
}

resource "aws_iam_role" "EnergymInstanceProfileRole" {
  name = "EnergymInstanceProfileRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "EnergymInstanceProfile" {
  name = "EnergymInstanceProfile"
  role = aws_iam_role.EnergymInstanceProfileRole.name
}
