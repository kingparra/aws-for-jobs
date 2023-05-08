#!/usr/bin/env bash
# This scripts automates the proceedures in the following demos videos.
# 1 DEMO - Create IAM Group 3:06 mins
# 2 DEMO - Create an IAM user with PowerUserAccess 4:17 mins
# 3 DEMO - Test IAM user with login and Policy Simulator 5:22 mins
# 4 DEMO - Create IAM Policy and test it 8:57 mins
# 5 DEMO - Create IAM Role 8:00 mins
# 6 DEMO - Enable MFA 5:27 mins

# 1 DEMO - Create IAM Group. 3:06 mins
######################################
# Create the PowerUsers group
aws iam create-group \
  --group-name PowerUsers

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


# 2 DEMO - Create an IAM user with PowerUserAccess 4:17 mins
############################################################
# Create a user
UserId=$(
  aws iam create-user \
    --user-name trainer \
    --query "User.UserId" \
    --output text
)

# Add the user to the PowerUsers group
aws iam add-user-to-group \
   --group-name PowerUsers \
   --user-name trainer


# 3 DEMO - Test IAM user w_ login and Policy Sim 5:22 mins
##########################################################
# Create access keys for trainer and store it
AccessKeyPair=$(
  aws iam create-access-key \
    --user-name trainer \
    --query "AccessKey.[AccessKeyId, SecretAccessKey]" \
    --output text
)

KeyId=$(cut -f1 -d $'\t' <<< "$AccessKeyPair")
KeySecret=$(cut -f2 -d $'\t' <<< "$AccessKeyPair")

# Create an awscli profile for trainer
echo "
[trainer]
aws_access_key_id = $KeyId
aws_secret_access_key = $KeySecret
" >> ~/.aws/credentials

# Test that the trainer user cannot access iam
aws --profile trainer iam list-users |& grep -o AccessDenied

# Run the policy simulator on the PowerUsers group
aws iam simulate-principal-policy \
 --policy-source-arn arn:aws:iam::355626928841:user/trainer \
 --action-names iam:ListUsers


# 4 DEMO - Create IAM Policy and test it. 8:57 mins
###################################################

# Create a new user named student
StudentUserId=$(
  aws iam create-user \
    --user-name student \
    --query "User.UserId" \
    --output text
)

# Create an access key for student
StudentAccessKeyPair=$(
  read user_name <<< student
  aws iam create-access-key \
    --user-name $userName \
    --query "AccessKey.[AccessKeyId, SecretAccessKey]" \
    --output text
)

StudentKeyId=$(cut -f1 -d $'\t' <<< "$StudentAccessKeyPair")
StudentKeySecret=$(cut -f2 -d $'\t' <<< "$StudentAccessKeyPair")

# Create an awscli profile for student
echo "
[$userName]
aws_access_key_id = $StudentKeyId
aws_secret_access_key = $StudentKeySecret
" >> ~/.aws/credentials

# Test that the new student user has no permissions by trying a few commands
aws --profile student s3 ls |& grep -o AccessDenied
aws --profile student s3 mb s3://student-bucket-test-yellowtail
aws --profile student ec2 describe-instances |& grep -o AccessDenied

# Create a policy named ListAllBucketsCreateBucketDeleteBucketPolicy
# (policy-document was generated with web console. What is Sid?)
aws iam create-policy \
  --policy-name ListAllBucketsCreateBucketDeleteBucketPolicy \
  --policy-document \
'{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:CreateBucket",
                "s3:DeleteBucket"
            ],
            "Resource": "*"
        }
    ]
}'

getPolicyArn() {
  aws iam list-policies \
    --query "Policies[?PolicyName=='$1'].Arn" \
    --output text
}

# Attach the policy to student
aws iam attach-user-policy \
  --user-name student \
  --policy-arn "$(getPolicyArn ListAllBucketsCreateBucketDeleteBucketPolicy)"

# Test that the student user can list, make and delete buckets
aws --profile student s3 ls
aws --profile student s3 mb --region us-east-1 s3://student-bucket-test-yellowtail
aws --profile student s3 ls
aws --profile student s3 rb s3://student-bucket-test-yellowtail
aws --profile student s3 ls
