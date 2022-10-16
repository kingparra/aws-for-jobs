#!/usr/bin/env bash
# Get the ami for the latest version of amazon linux 2.

# One way is by listing all of the available images matching the name
# amzn2-ami-hvm-2.0.*-x86_64-gp2 sorted by most recent creation date.
aws ec2 describe-images \
	--owners amazon \
	--region ap-northeast-1 \
	--query 'reverse(sort_by(Images, &CreationDate))[:1]' \
	--filters 'Name=name,Values=amzn2-ami-hvm-2.0.*-x86_64-gp2' \
	--output table

# Alternatively, look up the ami using a path, which returns the newest version
aws ssm get-parameters \
	--names /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2 \
	--region us-east-1
