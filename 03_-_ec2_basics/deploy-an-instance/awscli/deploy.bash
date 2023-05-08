#!/usr/bin/env bash
# This code is shit, but it helped me get familiar with what resources
# and actions ec2 provides, so I guess this was still a fruitful exercise.


# getLatestAmzlinuxAmi :: AmiId
getLatestAmzlinuxAmi() {
  aws ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
    --query 'Parameters[0].[Value]' \
    --output text
}


test_getLatestAmzlinuxAmi() {
  local image_description="$(aws ec2 describe-images --image-ids "$(getLatestAmzlinuxAmi)")"
  echo "$image_description" | jp "Images[0].Architecture == 'x86_64'" # cpu architecture
  echo "$image_description" | jp "Images[0].BlockDeviceMappings | length(@) == 1" # ami should only have one disk
  echo "$image_description" | jp "Images[0].CreationDate | starts_with(@, '$(date +%Y-%m)')" # ami was created this year and month
  echo "$image_description" | jp "Images[0].ImageLocation | starts_with(@, 'amazon/amzn2-ami-')" # namespace matches
  echo "$image_description" | jp "Images[0].OwnerId == '137112412989'" # the owner is amazon
  echo "$image_description" | jp "Images[0].PlatformDetails == 'Linux/UNIX'" # the ami contains a linux install
  echo "$image_description" | jp "Images[0].VirtualizationType == 'hvm'" # hardware acceleration rather than paravirtualization
}


# createSg :: Description
#          -> GroupName
#          -> IO ( CreateSecurityGroup Description GroupName Tags
#                , GroupId)
createSg() {
  aws ec2 create-security-group \
    --description "$1"\
    --group-name "$2" \
    --tag-specifications \
      'ResourceType=security-group,Tags=[{Key=Name,Value=Mod3Deploy}]' \
    --query 'GroupId' \
    --output text
}


# allowHttp :: GroupId -> IO (SecurityGroupIngress Http, SecurityGroupRuleId)
allowHttp() {
  aws ec2 authorize-security-group-ingress \
    --group-id "$1" \
    --cidr "0.0.0.0/0" \
    --protocol tcp \
    --port 80 \
    --query "SecurityGroupRules[].SecurityGroupRuleId" \
    --output text
}


# allowSsh :: GroupId -> IO (SecurityGroupIngress Ssh, SecurityGroupRuleId)
allowSsh() {
  aws ec2 authorize-security-group-ingress \
    --group-id "$1" \
    --cidr "0.0.0.0/0" \
    --protocol tcp \
    --port 22 \
    --query "SecurityGroupRules[].SecurityGroupRuleId" \
    --output text
}


# getPublicIp ::  InstanceId -> PublicIpAddress
getPublicIp() {
  aws ec2 describe-instances \
    --instance-id "$1" \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --output text
  }


createKeypair() {
  aws ec2 create-key-pair \
    --key-name "$1" \
    --key-type ed25519 \
    --query KeyMaterial \
    --tag-specifications \
      'ResourceType=security-group,Tags=[{Key=Name,Value=Mod3Deploy}]' \
    --output text
}


# deployInstances :: AmiId
#                 -> SecurityGroupId
#                 -> KeyName
#                 -> IO (CreateInstance, Table)
deployInstances() {
  aws ec2 run-instances                                                  \
    --instance-type t2.micro                                             \
    `# Instance must run Amazon Linux 2 as the Operating System`         \
    --image-id "$1"                                                      \
    --security-group-id "$2"                                             \
    --tag-specifications                                                 \
      'ResourceType=instance,Tags=[{Key=Name,Value=mod3deploy}]'         \
    --key-name "$3"                                                      \
    `# Instance must be patched and updated`                             \
    `# Run the following userdata script`                                \
    --user-data file://user-data.bash                                    \
    `# Enable Public IP using the associate_public_ip_address parameter` \
    --associate-public-ip-address                                        \
    --query "Instances[*].InstanceId"                                    \
    --output text
}


main() {
  # TODO Parameterize tags on all functions.
  # TODO Uniquely tag resources for each run of the script.
  # TODO Write an end-to-end test.
  # TODO Set up a CI job to run shellcheck on all bash scripts automatically.
  read sgid < <(createSg "Allow http and ssh ingress" "mod3deploysg") \
  && aws ec2 wait security-group-exists --group-ids "$sgid" \
  && allowSsh "$sgid" \
  && allowHttp "$sgid" \
  \
  && read keypair_id < <(createKeypair "mod3deploy" >| ~/.ssh/mod3deploy) \
  && aws ec2 wait key-pair-exists --key-names "mod3deploy" \
  && chmod 0600 ~/.ssh/mod3deploy \
  && ssh-add ~/.ssh/mod3deploy \
  \
  && read -r instance_id < <(deployInstances "$(getLatestAmzlinuxAmi)" "$sgid" mod3deploy) \
  && aws ec2 wait instance-running --instance_ids "$instance_id" \
  && until
    ssh  -q -o "BatchMode=yes" -o "ConnectTimeout=5" \
       -i ~/.ssh/mod3deploy.pem ec2-user@"$(getPublicIp "$instance_id")" \
      'echo "SSH connection successful"'
    do
      firefox "http://$(getPublicIp "$instance_id")/report.html"
    done
}


clean() {
  # TODO Use tags to determine what to delete.
  aws ec2 delete-key-pair --key-name mod3delploy
  aws ec2 terminate-instances --instance-ids "$instance_id"
  aws ec2 delete-security-group --group-name mod3deploysg
}
