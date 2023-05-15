resource "aws_iam_role" "EnergymInstanceProfileRole" {
  name = "EnergymInstanceProfileRole2" # EntityAlreadyExists bug workaround
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnergymInstanceProfileRoleAllowSts"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "S3full" {
  # arn:aws:iam::aws:policy/AmazonS3FullAccess
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "S3fullAttachment" {
  role = aws_iam_role.EnergymInstanceProfileRole.name
  policy_arn = data.aws_iam_policy.S3full.arn
}

resource "aws_iam_instance_profile" "EnergymInstanceProfile" {
  name = "EnergymInstanceProfile2" # EntityAlreadyExists bug workaround
  role = aws_iam_role.EnergymInstanceProfileRole.name
}
