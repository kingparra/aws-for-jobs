resource "aws_efs_file_system" "fs" {
  encrypted = true
}

resource "aws_efs_mount_target" "mt_1" {
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [module.nfs_client_1_sg.security_group_id]
}

resource "aws_efs_mount_target" "mt_2" {
  file_system_id = aws_efs_file_system.fs.id
  subnet_id = module.vpc.public_subnets[1]
  security_groups = [module.nfs_client_2_sg.security_group_id]
}

# TODO: break the policy document into a
# data "aws_iam_policy_document" block.
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.fs.id
    policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "ExamplePolicy01",
  "Statement": [
      {
          "Sid": "ExampleSatement01",
          "Effect": "Allow",
          "Principal": {
              "AWS": "*"
          },
          "Resource": "${aws_efs_file_system.fs.arn}",
          "Action": [
              "elasticfilesystem:ClientMount",
              "elasticfilesystem:ClientWrite"
          ],
          "Condition": {
              "Bool": {
                  "aws:SecureTransport": "true"
              }
          }
      }
  ]
}
POLICY
}
