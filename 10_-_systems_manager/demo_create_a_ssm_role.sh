#!/usr/bin/env bash
set -x

# demo_create_a_ssm_role
read0() { IFS=$'\0' read -r -d $'\0' "$@"; }

read0 policy_doc < <(\
cat << "EOF"
{
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
  --assume-role-policy-document "$policy_doc"

aws iam attach-role-policy \
  --role-name YellowTailSsmRoleForEc2 \
  --policy-arn \
  $(aws iam list-policies \
      --query 'Policies[?PolicyName==`AmazonSSMFullAccess`].Arn' \
      --output text)

aws iam create-instance-profile \
  --instance-profile-name YellowTailSsmRoleForEc2

aws iam add-role-to-instance-profile \
  --instance-profile-name YellowTailSsmRoleForEc2 \
  --role-name YellowTailSsmRoleForEc2

# demo_create_two_instances_and_attach_role

# demo_create_a_resource_group_and_add_two_instances
#
# Commands related to resource groups:
#   resourcegroupstaggingapi, resource-groups, resource-explorer-2
#
# aws resource-groups create-group \
#   --name MyResourceGroup \
#   --resource-query '{
#     "Type": "TAG_FILTERS_1_0",
#     "Query": {
#         "ResourceTypeFilters": [
#             "AWS::AllSupported"
#         ],
#         "TagFilters": [
#             {
#                 "Key": "Environment",
#                 "Values": [
#                     "Production"
#                 ]
#             }
#         ]
#     }
# }'
