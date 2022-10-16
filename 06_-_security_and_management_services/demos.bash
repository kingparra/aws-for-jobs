#!/usr/bin/env bash
#
# This scripts automates the proceedures in the following demos
#
# * DEMO - Create IAM Group. 3:06 mins
# * DEMO - Create an IAM user with PowerUserAccess 4:17 mins
# * DEMO - Test IAM user w_ login and Policy Sim 5:22 mins
# * DEMO - Create IAM Policy and test it. 8:57 mins
# * DEMO - Create IAM Role. 8:00 mins
# * DEMO - Enable MFA. 5:27 mins
#
# TODO
# Refactor this script to remove variable assignments and
# transition to functions piped together in main.
#
# TODO
# Add a random suffix to the username and groupname.
#
# TODO
# Write logic to clean up resources at the end of the script.
#
# TODO
# Write logic for error handling.
#

# Create the PowerUsers group
aws iam create-group \
  --group-name "$GroupName"

# look up the PolicyId of the PowerUserAccess policy
PolicyId=$(
  aws iam list-policies \
    --query "Policies[?PolicyName=='PowerUserAccess'].PolicyId" \
    --output text
)

# Associate the PowerUserAccess policy with the PowerUsers group
aws iam attach-group-policy \
  --policy-arn "$PolicyId" \
  --group-name PowerUsers

# Create a user
UserId=$(
  aws iam create-user \
    --user-name trainer \
    --query "User.UserId" \
    --output text
)

# Create access keys for trainer and store it
AccessKeyPair=$(
  aws iam create-access-key \
    --user-name trainer \
    --query "AccessKey.[AccessKeyId, SecretAccessKey]" \
    --output text \
)

KeyId=$(cut -f1 -d $'\t' <<< "$AccessKeyPair")
KeySecret=$(cut -f2 -d $'\t' <<< "$AccessKeyPair")

# Add the user to the PowerUsers group
aws iam add-user-to-group \
   --group-name PowerUsers \
   --user-name trainer

# Verify that the user exists
aws iam list-users \
  --query "Users[?UserName=='trainer'].UserId" \
  --output text

# Verify that trainer is in PowerUsers
aws iam list-groups-for-user \
   --user-name trainer \
   --query "Groups[].GroupName" \
   --output text

# Create an awscli profile for trainer
echo "
[trainer]
aws_access_key_id = $KeyId
aws_secret_access_key = $KeySecret
" >> ~/.aws/credentials

# Test that the trainer user cannot access iam
aws --profile trainer iam list-users |& grep -o AccessDenied

# Run the policy simulator on the PowerUsers group.
aws iam simulate-principal-policy \
 --policy-source-arn arn:aws:iam::355626928841:user/trainer \
 --action-names iam:ListUsers
