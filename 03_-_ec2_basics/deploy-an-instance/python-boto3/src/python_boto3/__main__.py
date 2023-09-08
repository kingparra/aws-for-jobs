#!/usr/bin/env python3
import boto3
import time
ec2client = boto3.client('ec2')
ec2 = boto3.resource('ec2')

img_response = ec2client.describe_images(
    Filters=[
        {'Name': 'name', 'Values': ['amzn2-ami-hvm-*']},
        {'Name': 'description', 'Values': ['Amazon Linux 2 AMI*']},
        {'Name': 'architecture', 'Values': ['x86_64']},
        {'Name': 'root-device-type', 'Values': ['ebs']},
    ],
    Owners=['amazon']
)

latest_ami_id = sorted(img_response['Images'],
                       key=lambda x: x['CreationDate'],
                       reverse=True)[0]['ImageId']

instance = ec2.create_instances(
    ImageId=latest_ami_id,
    InstanceType='t2.micro',
    KeyName='precision',
    NetworkInterfaces=[
        {
            'AssociatePublicIpAddress': True,
            'DeviceIndex': 0,
        },
    ],
    Monitoring={'Enabled': True},
    MinCount=1,
    MaxCount=1
    )[0]

# if the instance is up and has status OK, after 40 attempts
#   print the instance id and public ip address of that instance

try:
  instance.wait_until_running()
   # needed to refresh ip info https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2/instance/index.html#EC2.Instance
  instance.reload()
  print(f"{instance.instance_id} is up and running on {instance.public_ip_address}")
except e:
  print(f"{instance.instance_id} cannot launch")
