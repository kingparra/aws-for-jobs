#!/usr/bin/env bash

# In this project, students should
# follow the steps outlined below to
#   create an SNS topic and               -- sns:Topic 'chris-alarm-topic'
#   add subscription,                     -- sns:Subscription
# after that they will need to deploy an
#   EC2 instance on the default vpc,      -- ec2:Instance 'Stress-Test-Server'
#   in a plublic subnet
#   with a security group                 -- ec2:SecurityGroup
#   that allows ssh ingress               -- ec2:SecurityGroupRule
#   with a keypair                        -- ec2:KeyPairInfo
#   and also add an user data script.
# Finally they will create a
#   CloudWatch Alarm                      -- cloudwatch:MetricAlarm 'Chris-EC2-alarm'
# and that Alarm will trigger an
#   EC2 Action as well as the
#   SNS topic created.                    -- cloudwatch:

# topic chris-alarm-topic (standard), subscription, confirm, instance Stress-Test-Server, alarm (action: terminate) Chris-EC2-Alarm,


# 1. Create a topic
###################
aws sns create-topic --name chris-alarm-topic



# 2. Create a subscription to the topic
#######################################
read topic_arn < \
<(aws sns list-topics \
    --query "Topics[?contains(TopicArn,
             'chris-alarm-topic')].TopicArn" \
    --output text)

aws sns subscribe \
  --protocol email \
  --topic-arn "$topic_arn" \
  --notification-endpoint awsspam@pm.me \
&& firefox 'https://mail.proton.me/u/8/inbox'



# 3. Deploy an EC2 instance
###########################
read ami < \
<(aws ssm get-parameters --names \
/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
--query 'Parameters[0].[Value]' --output text)

read sgid < \
<(aws ec2 create-security-group \
  --description "SG for mod7 homework instance"\
  --group-name "Stress-Test-Server-SG" \
  --tag-specifications \
    'ResourceType=security-group,
     Tags=[{Key=ProjectName,Value=mod7_homework}]' \
  --query 'GroupId' \
  --output text)

aws ec2 authorize-security-group-ingress \
  --group-id "$sgid" \
  --cidr "0.0.0.0/0" \
  --protocol tcp \
  --port 22 \
  --query "SecurityGroupRules[].SecurityGroupRuleId" \
  --output text

createKeypair() {
  aws ec2 create-key-pair \
    --key-name "$1" \
    --key-type ed25519 \
    --query KeyMaterial \
    --output text
}

read instance_id < \
<(aws ec2 run-instances \
  --instance-type t2.micro \
  --image-id "$(getLatestAmzlinuxAmi)" \
  --security-group-id "$sgid" \
  --tag-specifications \
    'ResourceType=instance,
     Tags=[{Key=ProjectName,Value=Stress-Test-Server}]' \
  --key-name "$(createKeypair mod7hw)" \
  --user-data \
  '#!/bin/bash
   sudo yum install -y
   sudo amazon-linux-extras install epel -y
   sudo yum install stress -y' \
  --associate-public-ip-address \
  --query "Instances[*].InstanceId" \
  --output text
)



# 4. Create a CloudWatch alarm
##############################
# Per-Instance Metrics > CPUUtilization > 80% within 5 min
# send a notification to EC2-CPU-Alarm
# EC2 action > Terminate this instance
aws cloudwatch put-metric-alarm \
  --alarm-name "Terminate-Instance-Alarm" \
  --alarm-description "Terminate EC2 instance when CPU utilization is over 80% for 5 minutes" \
  --namespace AWS/EC2 --metric-name CPUUtilization \
  --threshold 80 --comparison-operator GreaterThanOrEqualToThreshold \
  --statistic Average --period 60 --evaluation-periods 5 \
  --dimensions Name=InstanceId,Value="$instance_id" \
  --actions-enabled --alarm-actions arn:aws:automate:region:ec2:terminate



# 5. Test that the alarm works
##############################
getInstanceIp() {
  aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=mod7_homework" \
    --query "Reservations[].Instances[].PublicIpAddress" --output text
}

ssh ec2-user@$(getInstanceIp) sudo systemd-run stress -c 4
aws ec2 wait instance-terminated --instance-ids "$(getInstanceIp)" \
&& echo "instance terminated successfully by action"


clean() {
  aws sns delete-topic --topic-arn "$topic_arn"
  aws sns unsubscribe --subscription-arn \
    "$( aws sns list-subscriptions \
          --query "[?Endpoint == 'awsspam@pm.me' &&
                     contains(TopicArn, 'chris-alarm-topic')
                   ].TopicArn"
          --output text)"
  read instance_ids < \
  <(aws ec2 describe-instances \
    --filters Name=tag:Name,Values=Stress-Test-Server \
    --query "Reservations[].Instances[].InstanceId" --output text)
  aws ec2 terminate-instances --instance-ids "$instance_ids"
  aws ec2 delete-security-group --group-name Stress-Test-Server-SG
  aws cloudwatch delete-alarms --alarm-names Chris-EC2-Alarm
}
