#!/usr/bin/env bash


# query specific info about your instances
aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].InstanceId'


# add a hearder or key to the field you query
aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].{InstanceID:InstanceId}'


# output information as a table
aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].{InstanceID:InstanceId}' \
	--output table
