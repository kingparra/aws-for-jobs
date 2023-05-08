#!/usr/bin/env bash


instances=$(aws ec2 describe-instances --filters Name=tag:Client,Values=Energym --output json)

echo "$instances" | jp "Reservations[].Instances[].InstanceType | all(@, == 't2.micro')"

read expected_output cat << "EOF"
[
  "t2.micro",
  "t2.micro",
  "t2.micro",
  "t2.micro",
  "t2.micro"
]
EOF
