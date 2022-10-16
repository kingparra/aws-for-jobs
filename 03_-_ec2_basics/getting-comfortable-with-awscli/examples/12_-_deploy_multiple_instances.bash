#!/usr/bin/env bash

# deploy instances in different ways
aws ec2 run-instances \
	--image-id ami-XXXXXXXX \
	--count 1 \
	--instance-type t2.micro

aws ec2 run-instances \
	--image-id ami-0abcdef1234567890 \
	--instance-type t2.micro \
	--key-name MyKeyPair

aws ec2 run-instances \
	--image-id XXXXXXXXXXX \
	--instance-type t2.micro \
	--subnet-id XXXXXXXXXXX \
	--security-group-ids XXXXXXXXXXX \
	--associate-public-ip-address \
	--key-name XXXXXXXXXXX

aws ec2 run-instances \
	--image-id XXXXXXXXXXX \
	--instance-type t2.micro \
	--count 1 \
	--subnet-id XXXXXXXXXXX \
	--key-name XXXXXXXXXXX \
	--security-group-ids XXXXXXXXXXX \
	--tag-specifications \
	`#do not indent this string literal#` \
	"ResourceType=XXXXXXXXXXXXX,\
Tags=[{Key=XXXXXXXXXXX,Value=XXXXXXXXXXX},\
{Key=XXXXXXXXXXX,Value=XXXXXXXXXXX}]"

aws ec2 run-instances \
	--image-id XXXXXXXXXXX \
	--instance-type t2.micro \
	--count 1 \
	--subnet-id XXXXXXXXXXX \
	--key-name XXXXXXXXXXX \
	--security-group-ids XXXXXXXXXXX \
	--user-data file://my_script.txt
