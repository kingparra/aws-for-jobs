#!/usr/bin/env python3
import boto3

ec2client = boto3.client('ec2') # returns json
ec2 = boto3.resource('ec2') # returns objects

# Generatea list of amazon linux 2 ami ids
img_response = ec2client.describe_images(
    Filters=[
        {'Name': 'name', 'Values': ['amzn2-ami-hvm-*']},
        {'Name': 'description', 'Values': ['Amazon Linux 2 AMI*']},
        {'Name': 'architecture', 'Values': ['x86_64']},
        {'Name': 'root-device-type', 'Values': ['ebs']},
    ],
    Owners=['amazon']
)

# Get the most recent ami from the list
latest_ami_id = sorted(img_response['Images'],
                       key=lambda x: x['CreationDate'],
                       reverse=True)[0]['ImageId']

# Create a security group that allows ssh ingress
sg = ec2.create_security_group(
  GroupName='boto3-instance-sg',
  Description='SG for instance created with boto3'
)

sg.authorize_ingress(
    IpPermissions=[
        {
            'IpProtocol': 'tcp',
            'FromPort': 22,
            'ToPort': 22,
            'IpRanges': [{'CidrIp': '0.0.0.0/0'}]
        }
    ]
)

# Create an instance with the latest amazon linux 2 ami,
# our security group, and the keypair 'precision'.
# Use 't2.micro' as the instance type.
# Name it 'boto3-instance'.
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
    SecurityGroupIds=[sg.id],
    TagSpecifications=[{
      'ResourceType': 'instance',
      'Tags': [{'Key': 'Name', 'Value': 'boto3-instance'}]}],
    Monitoring={'Enabled': True},
    MinCount=1,
    MaxCount=1
    )[0]

try:
  # Wait until the instance is up
  instance.wait_until_running()
  # Refresh the ip info
  instance.reload()
  print(f"{instance.instance_id} is up and running on {instance.public_ip_address}")
except e:
  print(f"{instance.instance_id} cannot launch")
