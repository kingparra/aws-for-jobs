#!/usr/bin/env python3
import boto3
import pprint
ec2 = boto3.client('ec2')

img_response = ec2.describe_images(
    Filters=[
        {'Name': 'name', 'Values': ['amzn2-ami-hvm-*']},
        {'Name': 'description', 'Values': ['Amazon Linux 2 AMI*']},
        {'Name': 'architecture', 'Values': ['x86_64']},
        {'Name': 'root-device-type', 'Values': ['ebs']},
    ],
    Owners=['amazon']
)

# Sort the images by creation date in descending order to get the latest one
images = sorted(img_response['Images'], key=lambda x: x['CreationDate'], reverse=True)

# Extract the latest Amazon Linux 2 AMI ID
latest_ami_id = images[0]['ImageId']

response = ec2.run_instances(
    ImageId=latest_ami_id,
    InstanceType='t2.micro',
    KeyName='precision',
    NetworkInterfaces=[
        {
            'AssociatePublicIpAddress': True,
            'DeviceIndex': 0,
        },
    ],
    MinCount=1,
    MaxCount=1
    )


instance_id = response['Instances'][0]['InstanceId']

print(f"Launched EC2 instance with ID: {instance_id}")

def get_instance_public_ip(instance_id):
 return ec2.describe_instances(InstanceIds=[instance_id])['Reservations'][0]['Instances'][0]['PublicIpAddress']

print(f"public ip address: {get_instance_public_ip(instance_id)}")
