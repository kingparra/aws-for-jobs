#!/usr/bin/env bash

# Demo: Create an IAM role

# Create a role
###############
# role-name: YellowTailEC2ForSSMRole
# service: ec2
# policy: AmazonEC2RoleforSSM

#Create a role named YellowTailEC2ForSSMRole with the ec2 policy AmazonEC2RoleforSSM attached
#############################################################################################

# Create three EC2 instances with the YellowTailEC2ForSSMRole attached.
#######################################################################
# Timestamp in video 03:22
#
# type           : t2.micro
# ami            : the latest amazon linux ami
# subnet         : Choose one in the us-east-1a AZ.
# tags           : {"Name"                           : "SSM Managed Instance"}
# iam group      : YellowTailEC2ForSSMRole
# security group : Create a new sg with SSH allowed.
#
# The IAM group shows up as "IAM Instnace Profile" in the web interface.
