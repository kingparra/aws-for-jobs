#!/usr/bin/env bash
set -x
#
# This script is meant to be run interactively, one function at a time.
# It's almost a straight-line script in the sense that there are dependencies
# between bodies of each of the functions that arent parameterized.
# They're not really functions, but sections, instead.

# USAGE
#
# $ ./deploy.sh createRole
#

# Why do I write lab solutoins in bash? It's objetively the wrong tool for the
# job. Awscli has helped me get familiar with managing the lifecycle of resources.
# In the process of crafting --query strings, I've had to view the json output of
# the resources a lot, too. So it's helped me become familar with metadata is
# available, and it's more fun than reading the api docs directly.
# Finally, using aws cli let's me communicate with people who don't use
# Terraform, CloudFormation, or whatever IaC tool I happen to be using at the
# moment. The common denominator is AWS itself, rather than the IaC tooling.
# This is both good and bad: Tt's often more useful to talk at a higher
# level of abstraction, and the skills I gain here are not portable to other
# cloud providers. But when things go wrong, lower-level details often matter.


createRole() {
  # instance -> instance profile -> {role & inline arpolicy -> managed policy -> policy document}
  aws iam create-role \
    --role-name EnergymInstanceProfileRole \
    --tags \
      'Key=Client,Value=Energym' \
    --assume-role-policy-document \
      '{
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

  aws iam attach-role-policy \
    --role-name EnergymInstanceProfileRole \
    --policy-arn "$(
      aws iam list-policies \
        --scope AWS \
        --query 'Policies[?PolicyName==`AmazonS3FullAccess`].Arn' \
        --output text)"

  aws iam create-instance-profile \
   --tags \
     'Key=Client,Value=Energym' \
    --instance-profile-name EnergymInstanceProfile

  aws iam add-role-to-instance-profile \
    --instance-profile-name EnergymInstanceProfile \
    --role-name EnergymInstanceProfileRole
}


createSg() {
  aws ec2 create-security-group \
    --group-name EnergymSiteSG \
    --description "Allow HTTP ingress from anywhere and SSH from my ip for static site." \
    --tag-specifications "ResourceType=security-group,Tags=[{Key=Client,Value=Energym}]"
}


createKeyPair() {
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/Energym
  chmod 0600 ~/.ssh/Energym
  ssh-add ~/.ssh/Energym
  aws ec2 import-key-pair \
    --key-name EnergymKeyPair \
    --public-key-material "fileb://$HOME/.ssh/Energym.pub"
}


createInstance() {
  # Create an instance that will serve as the basis for our golden image.
  aws ec2 run-instances \
    --image-id "$(
      aws ssm get-parameters \
      --names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
      --query 'Parameters[0].[Value]' \
      --output text)" \
    --instance-type t2.micro \
    --key-pair EnergymKeyPair \
    --block-device-mappings \
      '[
        {
          "DeviceName": "/dev/xvda",
          "Ebs": {
            "VolumeSize": 16,
            "VolumeType": "gp2"
          }
        }
      ]' \
    --iam-instance-profile "Name=EnergymInstanceProfile" \
    --security-group-ids "$(
      aws ec2 describe-security-groups \
        --filters 'Name=tag:Client,Values=Energym' \
        --query 'SecurityGroups[?GroupName==`EnergymSiteSG`]'

      )" \
    --user-data \
      "#!/usr/bin/env bash
      set -xeuo pipefail
      sudo yum update -y
      sudo yum install -y httpd
      sudo systemctl enable --now
      sudo aws s3 sync s3://yt-websites-2023/energym-html /var/www/html" \
    --tag-specifications \
      "ResourceType=instance,Tags=[
         {Key=Client,Value=Energym},
         {Key=Name,Value=BasisForGoldenImage}
      ]"
}


testInstance() {
  read ipaddr < <(aws ec2 describe-instances \
                    --filters Name=tag:Client,Values=Energym \
                              Name=tag:Name,Values=BasisForGoldenImage \
                    --query "Reservations[].Instances[].PublicIpAddress | [0]" \
                    --output text)

  # test that the service is running and enabled
  ssh ec2-user@"$ipaddr" sudo systemctl is-running httpd
  ssh ec2-user@"$ipaddr" sudo systemctl is-enabled httpd

  # test that the website responds with html
  if curl "$ipaddr"; then echo success; else logger -p info 'no response from page'; fi
}


createAmi() {
  # Snapshot the golden image instance
  aws ec2 create-snapshot \
    `# Name = GoldenSnapshot #` \
    --tag-specifications "ResourceType=snapshot,Tags=[
                            {Key=Name,Value=GoldenSnapshot},
                            {Key=Client,Value=Energym}
                          ]" \
    --volume-id "$(
      aws ec2 describe-instances \
        --filters Name=tag:Client,Values=Energym \
                  Name=tag:Name,Values=BasisForGoldenImage \
        --query "Reservations[].Instances[].BlockDeviceMappings[?DeviceName=='/dev/xvda'].Ebs.VolumeId" \
        --output text)"
  # Get the image id of the snapshot we just created
  read snapshotId < \
    <(aws ec2 describe-snapshots \
        --owner-ids self \
        --query "Snapshots[?Tags[?Key=='Name' && Value=='GoldenSnapshot'] &&
                            Tags[?Key=='Client' && Value=='Energym']].SnapshotId | [0]" \
        --output text)
  # Wait for the snapshot to complete, and then create an AMI
  aws ec2 wait snapshot-completed --snapshot-ids "$snapshotId" && \
  aws ec2 register-image \
    --name "GoldenImage" \
    --description "An AMI created from my our GolednSnapshot" \
    --root-device-name /dev/xvda \
    --block-device-mappings "DeviceName=/dev/xvda,Ebs={SnapshotId=$snapshotId}"
}


createLaunchTemplate() {
  local launch_template_data
  IFS=$'\0' read -d $'\0' -r launch_template_data < \
    <(cat << EOF
{
  "NetworkInterfaces": [
    {
      "DeviceIndex": 0,
      "AssociatePublicIpAddress": true,
      "Groups": [
        "$(aws ec2 describe-security-groups \
             --filters 'Name=tag:Client,Values=Energym' \
             --query 'SecurityGroups[?GroupName==`EnergymSiteSG`].GroupId |[0]' \
             --output text)"
      ],
      "DeleteOnTermination": true
    }
  ],
  "ImageId": "$(aws ec2 describe-images --owners self --query 'Images[?Name==`GoldenImage`].ImageId' --output text)",
  "InstanceType": "t2.micro",
  "TagSpecifications": [
    {
      "ResourceType": "instance",
      "Tags": [
        { "Key": "Client", "Value": "Energym" },
        { "Key": "Name", "Value": "EnergymStaticSiteInstance" }
      ]
    },
    {
      "ResourceType": "volume",
      "Tags": [
        { "Key": "Client", "Value": "Energym" }
      ]
    }
  ],
  "BlockDeviceMappings": [
    {
      "DeviceName": "/dev/xvda",
      "Ebs": { "VolumeSize": 16 }
    }
  ]
}
EOF
)

  aws ec2 create-launch-template \
    --launch-template-name EnergymStaticSiteLt \
    --version-description 'V1: Static files and apache set up' \
    --launch-template-data "$launch_template_data"
}



createAlb() {
  # Get the vpc id of the default vpc
  defaultVpcId=$(aws ec2 describe-vpcs \
                   --filters "Name=isDefault,Values=true" \
                   --query 'Vpcs[0].VpcId' \
                   --output text)

  # Create an application load balancer
  aws elbv2 create-load-balancer \
    --name EnergymAlb \
    --subnets $(aws ec2 describe-subnets \
                 --query "Subnets[?VpcId=='$defaultVpcId'].SubnetId" \
                 --output text) \
    --security-groups "$(aws ec2 describe-security-groups \
                            --group-names EnergymSiteSG \
                            --query "SecurityGroups[].GroupId | [0]" \
                            --output text)"


}


createAsg() {

  aws elbv2 create-target-group \
    --name EnergymTargetGroup \
    --protocol HTTP \
    --port 80 \
    --vpc-id $(aws ec2 describe-vpcs \
                 --filters "Name=isDefault,Values=true" \
                 --query 'Vpcs[0].VpcId' \
                 --output text) \
    --tags 'Key=Client,Value=Energym' 'Key=Name,Value=EnergymTargetGroup'\


  # Template this json and read it into the asg_json variable.
  local asg_json
  IFS=$'\0' read -d $'\0' -r asg_json < \
  <(cat << EOF
{
  "LaunchTemplateId": "$(aws ec2 describe-launch-templates \
                            --launch-template-names EnergymStaticSiteLt \
                            --query 'LaunchTemplates[].LaunchTemplateId' \
                            --output text)",
  "Version": "$(aws ec2 describe-launch-templates \
                  --launch-template-names EnergymStaticSiteLt \
                  --query 'LaunchTemplates[].LatestVersionNumber | [0]' \
                  --output text)"
}
EOF
)

  # wiat for the Alb to come up and then create an Asg
  aws elbv2 wait load-balancer-available --load-balancer-arns "$(
    aws elbv2 describe-load-balancers \
       --names EnergymAlb \
       --query 'LoadBalancers[*].LoadBalancerArn' \
       --output text)" \
  &&
  aws autoscaling create-auto-scaling-group \
    --auto-scaling-group-name EnergymAsg \
    --tags 'Key=Client,Value=Energym' \
    --min-size 1 \
    --desired-capacity 2 \
    --max-size 5 \
    --default-instance-warmup 30 \
    --launch-template "$asg_json" \
    --availability-zones us-east-1{a,b,c,d} \
    --target-group-arns "$(
      aws elbv2 describe-target-groups \
        --names EnergymTargetGroup \
        --query "TargetGroups[].TargetGroupArn | [0]" \
        --output text)"

    # How are target groups, ALBs, and ASGs related?

  read target_tracking_policy <(cat << EOF
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ASGAverageCPUUtilization"
  },
  "TargetValue": 70
}
EOF
)
  # Create a traget tracking sacling policy
  aws autoscaling put-scaling-policy \
    --policy-name EnergymAsgTargetTracking \
    --policy-type TargetTrackingScaling \
    --auto-scaling-group-name EnergymAsg \
    --target-tracking-configuration "file://$target_tracking_policy" \
    --cooldown 300
}


"$@"
