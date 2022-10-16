#!/usr/bin/env bash
# Answer to Module 3, Assignment 3.
# https://learn.yellowtail.tech/unit/view/id:11732
#
# Security group settings.
#
yt() { aws --profile yellowtail "$@"; }

# createSg :: Description
#          -> GroupName
#          -> IO (CreateSecurityGroup Description GroupName Tags
#                , GroupId)
createSg() {
  yt ec2 create-security-group \
    --description "$1"\
    --group-name "$2" \
    --tag-specifications \
      'ResourceType=security-group,Tags=[{Key=Name,Value=Mod3Deploy}]' \
    --query 'GroupId' \
    --output text
}

# getSgId :: GroupName -> GroupId
getSgId() {
   yt ec2 describe-security-groups \
    --query "SecurityGroups[?GroupName=='${1}'].GroupId" \
    --output text
}

# getSubnetId :: Region -> SubnetId
getSubnetId() {
  yt ec2 describe-subnets \
    --query "Subnets[?AvailabilityZone=='${1}'].SubnetId" \
    --output text
}

# allowHttp :: GroupId -> IO (SecurityGroupIngress Http, SecurityGroupRuleId)
allowHttp() {
  yt ec2 authorize-security-group-ingress \
    --group-id "$1" \
    --cidr "0.0.0.0/0" \
    --protocol tcp \
    --port 80 \
    --query "SecurityGroupRules[].SecurityGroupRuleId" \
    --output text
}


# allowHttp :: GroupId -> IO (SecurityGroupIngress Ssh, SecurityGroupRuleId)
allowSsh() {
  yt ec2 authorize-security-group-ingress \
    --group-id "$1" \
    --cidr "0.0.0.0/0" \
    --protocol tcp \
    --port 22 \
    --query "SecurityGroupRules[].SecurityGroupRuleId" \
    --output text
}

main() {
  read -r sgid < <(createSg mod3deploy "Sg for mod 3, assignment 3, ec2-user@ec2-44-201-134-144.compute-1.amazonaws.com")
}
