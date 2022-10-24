# NOTE
#
# Modules correspond to directories.
#
# A module is a collection of .tf and/or .tf.json files
# kept together in a directory.
#
# Terraform evaluates all of the configuration files
# in a module, effectively treating the entire module as a single document.
#
# To import a module, use the following
#
# module "modulename" {
#   source = "whatever" # required
#   version = "I don't care" # required
#   some_input_variable = "value"
# }
#
# This is almost like constructing an object,
# or calling a function, no?
#
# after adding a module, run terraform init

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  # Retrive the aws credentials from ~/.aws/credentials
  region                   = var.account_details["region"]
  shared_config_files      = var.account_details["shared_config_files"]
  shared_credentials_files = var.account_details["shared_credentials_files"]
}


# DEMO Create a launch configuration
####################################
resource "aws_security_group" "sg" {
  name        = "ASGSecurityGroup"
  description = "Allow SSH traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  # Terraform removes the default rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Mod8Demo"
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_launch_configuration" "lc" {
  name            = "my-yellowtail-launch-configuration"
  image_id        = data.aws_ami.amazon-linux-2.image_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg.id]
}


# DEMO Create an auto scaling group
###################################
resource "aws_autoscaling_group" "asg" {
  name                 = "my-yellowtail-ASG"
  launch_configuration = "my-yellowtail-launch-configuration"
  min_size             = 1
  max_size             = 5
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"]
  lifecycle {
    create_before_destroy = true
  }
}


# DEMO Create a simple scaling policy
#####################################
# resource "aws_cloudwatch_metric_alarm" "gte80alarm" {
#   alarm_name                = "YellowTailCPUOver80PercentAlarm"
#   comparison_operator       = "GreaterThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "80"
#   dimensions = {
#     AutoScalingGroupName = "my-yellowtail-ASG"
#   }
#   # alarm_actions = toset([""])
#   tags = {
#     Name = "Mod8Demo"
#   }
# }


# resource "aws_cloudwatch_metric_alarm" "lte20alarm" {
#   alarm_name                = "YellowTailCPUUnder20PercentAlarm"
#   comparison_operator       = "LessThanOrEqualToThreshold"
#   evaluation_periods        = "2"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "20"
#   dimensions = {
#     AutoScalingGroupName = "my-yellowtail-ASG"
#   }
#   tags = {
#     Name = "Mod8Demo"
#   }
# }


# resource "aws_autoscaling_policy" "sp1" {
#   name = "YellowTailSimpleScalingPolicy"
#   scaling_adjustment = 2
#   adjustment_type = "ChangeInCapacity"
#   policy_type = "SimpleScaling"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
#   # How do I associate the alarm with the policy?
#   # How do I use the policy to trigger an alarm?
# }


# resource "aws_autoscaling_policy" "sp2" {
#   name = "YellowTailSimpleScalingPolicy2"
#   scaling_adjustment = 2
#   adjustment_type = "ChangeInCapacity"
#   policy_type = "SimpleScaling"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
# }


# resource "aws_autoscaling_policy" "sp3" {
#   name = "Target Tracking Policy"
#   policy_type = "SimpleScaling"
#   autoscaling_group_name = aws_autoscaling_group.asg.name
# }
