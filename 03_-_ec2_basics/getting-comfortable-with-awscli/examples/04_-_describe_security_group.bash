#!/usr/bin/env bash

# describe security group
aws ec2 describe-security-groups \
	--filters 'Name=group-name,Values=SSH*'

aws ec2 describe-security-groups \
	--filters 'Name=group-name,Values=SSH*' \
	--query 'SecurityGroups[*].{SGname:GroupName, SGID:GroupId}'
