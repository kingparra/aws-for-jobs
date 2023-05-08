resource "aws_iam_instance_profile" "s3_access_instance_profile" {
  name = "s3_access_instance_profile"
}

resource "aws_iam_instance_profile_role_association" "s3_access_instance_profile_role_association" {
  instance_profile = aws_iam_instance_profile.s3_access_instance_profile.name
  role             = aws_iam_role.s3_access_role.name
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3_access_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3_access_policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.bucket.arn}", "${aws_s3_bucket.bucket.arn}}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.s3_access_role.name
}
