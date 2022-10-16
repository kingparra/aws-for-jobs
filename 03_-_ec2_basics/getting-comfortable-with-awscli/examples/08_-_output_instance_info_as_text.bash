#!/usr/bin/env bash

# output information as a text
aws ec2 describe-instances \
	--query 'Reservations[*].Instances[*].{InstanceID:InstanceId}' \
	--output text

# filter by running instances
aws ec2 describe-instances \
	--filters 'Name=instance-state-name,Values=running'

# filter by stopped instances
aws ec2 describe-instances \
	--filters 'Name=instance-state-name,Values=stopped'

# filter by tag
aws ec2 describe-instances \
	--filters 'Name=tag:Env, Values=Prod'
