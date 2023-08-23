#!/usr/bin/env bash


# Create AWS VPC (Virtual Private Cloud)
########################################
createMyVpc() {
  aws ec2 create-vpc --cidr-block "10.0.0.0/16" --tag-specifications "ResourceType='vpc',Tags=[{Key='Name',Value='my-vpc'}]"
}


getMyVpc() {
  aws ec2 describe-vpcs --filters "Name='tag:Name',Values='my-vpc'" --query "Vpcs[].VpcId" --output text
}




# Create Public and Private Subnets
###################################
# createSubnet :: VpcId
#              -> Cidr
#              -> Az
#              -> NameTagValue
#              -> SeedTagValue
createSubnet() {
  aws ec2 create-subnet \
    --vpc-id "$1" \
    --cidr-block "$2" \
    --availability-zone "$3" \
    --tag-specifications \
      "ResourceType='subnet',Tags=[{Key='Name',Value='$4'},{Key='Seed',Value='$5'}]"
}


# createPubPrivSubnets :: VpcId -> IO ([SubnetId],[CreateSubnet Subnet])
createPubPrivSubnets() {
  createSubnet "$1" "$2" "10.0.0.0/24" us-east-1a public-subnet-1
  createSubnet "$1" "$2" "10.0.1.0/24" us-east-1b public-subnet-2
  createSubnet "$1" "$2" "10.0.2.0/24" us-east-1c private-subnet-1
  createSubnet "$1" "$2" "10.0.3.0/24" us-east-1d private-subnet-2
}


getPubPrivSubnets() {
  aws ec2 describe-subnets \
      --filters "Name='tag:Name',
                 Values=['public-subnet-1',
                         'public-subnet-2',
                         'private-subnet-1',
                         'private-subnet-2']" \
      --query "Subnets[].SubnetId" \
      --output text
}


getPubSubnet1() {
  aws ec2 describe-subnets \
    --filters "Name='tag:Name',Values=['public-subnet-1']" \
    --query "Subnets[].SubnetId" \
    --output text
}




# Create Internet Gateway (IGW)
###############################
createIGW() {
  aws ec2 create-internet-gateway \
    --tag-specifications \
      "ResourceType='internet-gateway',Tags=[{Key='Name',Value='my-internet-gateway'}]"
}


getMyIgw() {
aws ec2 describe-internet-gateways \
      --filters "Name='tag:Name',Values='my-internet-gateway'" \
      --query "InternetGateways[].InternetGatewayId" \
      --output text
}




# Create NAT Gateway
####################
createMyNgw() {
  local subnetId=subnet-00dd39524650b70e1
  local eipId=eipalloc-0df9d7fc663b5d13f
  aws ec2 create-nat-gateway \
    --allocation-id "${1:-$eipId}" \
    --subnet-id "${2:-$subnetId}"
}


# createMyEip :: NameTagValue
createMyEip() {
  aws ec2 allocate-address \
    --tag-specifications \
      "ResourceType='elastic-ip',Tags=[{Key='Name',Value='$1'}]"
}


# getSubnet :: NameTagValue
getSubnet() {
  aws ec2 describe-subnets \
    --filter "Name='tag:Name',Values='$1'" \
    --query "Subnets[].SubnetId" \
    --output text
}


# getEip :: NameTagValue
getEip() {
  aws ec2 describe-addresses \
    --filter "Name='tag:Name',Values='$1'" \
    --query "Addresses[].AllocationId" \
    --output text
}




# Attach the IGW to our VPC
###########################
attachMyIgw() {
  aws \
    ec2 attach-internet-gateway \
    --vpc-id "$1" \
    --internet-gateway-id "$2"
}


attachMyIgwToMyVpc() {
  attachMyIgw vpc-0a711d28c7f1aecaa igw-0c3927f792b21cd3a
}




# Configure route tables
########################

# createRouteTable :: RouteTableName -> IO (CreateRouteTable RouteTable)
createRouteTable() {
  name=$1
  aws ec2 create-route-table \
    --vpc-id \
      "$(aws ec2 describe-vpcs \
          --query \
            "Vpcs[?(Tags[?Key=='Name'].Value | [0]) == 'my-vpc'].VpcId" \
          --output text)" \
    --tag-specifications \
      "ResourceType='route-table',Tags=[{Key='Name',Value='$name'}]"
}




# Create a Bastion host on a public subnet
##########################################
getLatestAmzLinuxAMI() {
  aws ssm get-parameters \
     --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
     --query 'Parameters[0].[Value]' \
     --output text
}


createMySg() {
  aws ec2 create-security-group \
    --group-name SG-bastion \
    --description "Enter SG for bastion host. SSH access only." \
    --vpc-id vpc-0a711d28c7f1aecaa \
    --tag-specifications \
      "ResourceType='security-group',Tags=[{Key='Name',Value='my-sg'}]"
}

getMySg() (
  getSg() {
    aws ec2 describe-security-groups \
      --filter "Name='tag:Name',Values='$1'" \
      --query "SecurityGroups[].GroupId" \
      --output text
  }
  getSg my-sg
)


# createBastionHost :: AmiId
#                   -> SubnetId
#                   -> [SecurityGroupId]
#                   -> IO (CreateInstance Instance, InstanceId)
createBastionHost() {
  aws ec2 run-instances \
    --associate-public-ip-address \
    --instance-type t2.micro \
    --image-id "$1" \
    --subnet-id "$2" \
    --security-group-ids "$3" \
    --key-name yellowtail-ec2-ed25519 \
    --tag-specifications \
      "ResourceType='instance',Tags=[{Key='Name',Value='my-instance'}]"
}


# Main
######
main() {
  randomSeed="$(pwqgen | tr -dc '[:alpha:]')"
  createBastionHost "$(getLatestAmzLinuxAMI)" "$(getPubSubnet1)" "$(getMySg)"
}
