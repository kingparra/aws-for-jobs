#!/usr/bin/env bash

# Create a role that authorizes the ec2 service to run any systems manager actions.
read0() { IFS=$'\0' read -r -d $'\0' "$@"; }

read0 policy_doc < <(cat << EOF
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
}
EOF
)

aws iam create-role \
  --role-name YellowTailSsmRoleForEc2 \
  --assume-role-policy-document $policy_doc

aws iam attach-role-policy \
  --role-name YellowTailSsmRoleForEc2 \
  --policy-arn \
  $(aws iam list-policies \
      --query 'Policies[?PolicyName==`AmazonSSMFullAccess`].Arn' \
      --output text)

aws iam create-instance-profile \
  --instance-profile-name AmazonSSMFullAccess

aws iam add-role-to-instance-profile \
  --instance-profile-name AmazonSSMFullAccess \
  --role-name YellowTailSsmRoleForEc2
