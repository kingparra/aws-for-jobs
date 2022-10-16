#!/usr/bin/env bash
# Answer to Module 3, Assignment 3.
# https://learn.yellowtail.tech/unit/view/id:11732
#
# Instance settings
#
yt() { aws --profile yellowtail "$@"; }

# getLatestAmzlinuxAmi :: AmiId
getLatestAmzlinuxAmi() {
  yt ssm get-parameters \
    --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
    --query 'Parameters[0].[Value]' \
    --output text
}


# getSubnetId :: Region -> SubnetId
getSubnetId() {
  yt ec2 describe-subnets \
    --query "Subnets[?AvailabilityZone=='${1}'].SubnetId" \
    --output text
}

# deployInstances :: AmiId
#                 -> SubnetId
#                 -> SecurityGroupId
#                 -> IO (CreateInstance, Table)
deployInstances() {
  yt ec2 run-instances                                                   \
    --instance-type t2.micro                                             \
    `# Instance must run Amazon Linux 2 as the Operating System`         \
    --image-id "$1"                                                      \
    `# Instance must run in a public subnet`                             \
    --subnet-id "$2"                                                     \
    --security-group-id "$3"                                             \
    --tag-specifications                                                 \
      'ResourceType=instance,Tags=[{Key=Name,Value=mod3deploy}]'         \
    --key-name yellowtail-ec2-ed25519                                    \
    `# Instance must be patched and updated`                             \
    `# Run the following userdata script`                                \
    --user-data file://user-data.bash                                    \
    `# Enable Public IP using the associate_public_ip_address parameter` \
    --associate-public-ip-address                                        \
    --query "Instances[*].InstanceId"                                    \
    --output text
}


# getPublicIp ::  InstanceId -> PublicIpAddress
getPublicIp() {
  yt ec2 describe-instances \
    --instance-id "$instance_id" \
    --query "Reservations[].Instances[].PublicIpAddress" \
    --output text
  }


# main :: IO ()
# WARN Global variables live here!
# This is terrible code, I should rewrite this.
main() {
  read -r instance_id        < \
    <(deployInstances "$(getLatestAmzlinuxAmi)" "$(getSubnetId us-east-1c)" \
                      "$(getSgId us-east-1c)")
  echo "instance $instance_id created"
  echo "public ip addr: $(getPublicIp "$instances_id")"
  # Currently, the security group isn't being created,
  # the instance isn't getting associated to it,
  # and the intsance doesn't get a keypair.
}


cleanup() {
  yt ec2 delete-security-group --group-name mod3deploy
}
