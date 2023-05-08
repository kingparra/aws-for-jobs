#!/usr/bin/env bash

packages=(
  # https://github.com/aws/amazon-cloudwatch-agent
  amazon-cloudwatch-agent
  collectd
)

sudo yum install -y "${packages[@]}"

# cat config.json > /opt/aws/amazon-cloudwatch-agent/bin/config.json
# https://github.com/christiangda/ansible-role-amazon-cloudwatch-agent

amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
  -s
