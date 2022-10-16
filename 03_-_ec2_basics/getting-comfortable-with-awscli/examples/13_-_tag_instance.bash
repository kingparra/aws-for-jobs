#!/usr/bin/env bash

# add tags to existing ec2
aws ec2 create-tags \
	--resources XXXXXXXXXXX \
	--tags 'Key=Stack,Value=production'
