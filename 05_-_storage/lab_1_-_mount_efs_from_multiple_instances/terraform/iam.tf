resource "aws_iam_role" "ec2-role" {
  # Allow the ec2 service to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid = "",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2-role-policy" {
  role = aws_iam_role.ec2-role.id
  # Allow clients to write and mount EFS shares
  # for the efs fs we created, if they have the
  # role "ec2-role".
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite"
      ],
      "Effect": "Allow",
      "Resource": "${aws_efs_file_system.fs.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ec2-profile" {
  role = aws_iam_role.ec2-role.name
}

data "aws_iam_policy_document" "instance_policy" {
  # Allow the ec2 instances to assume the role "ec2-role".
  statement {
    sid    = "EfsInstanceAccessPolicy"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
    ]
    resources = [aws_efs_file_system.fs.arn]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}
