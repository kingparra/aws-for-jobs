#!/usr/bin/env bash

# Here's an example of how to format the AWS CLI commands to grant a user the
# ability to pass any of the approved set of roles to the Amazon EC2 service
# upon launching an instance.

# Note: Replace the AWS account ID, IAM user name, IAM policy name, IAM role name, and approved role ARNs with your own values.

# Create an IAM policy that allows the user to pass only those roles that are approved.
aws iam create-policy \
  --policy-name PassRolePolicy \
  --policy-document '
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "iam:GetRole"
            ],
            "Resource": [
                "arn:aws:iam::123456789012:role/approved-role-1",
                "arn:aws:iam::123456789012:role/approved-role-2"
            ]
        }
    ]
}'


# Attach the IAM policy to the IAM user.
aws iam attach-user-policy \
  --user-name username \
  --policy-arn arn:aws:iam::123456789012:policy/PassRolePolicy

# Create a trust policy for the role that allows the service to assume the role.
aws iam create-role \
  --role-name myRole \
  --assume-role-policy-document '
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}'

# Attach the IAM policy to the IAM role.
aws iam attach-role-policy \
  --role-name myRole \
  --policy-arn arn:aws:iam::123456789012:policy/PassRolePolicy
