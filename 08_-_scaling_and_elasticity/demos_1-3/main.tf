terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# DEMO Create a launch configuration
resource "aws_security_group" "sg" {
  name = "ASGSecurityGroup"
  description = "Allow SSH traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "Mod8Demo" }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "lc" {
  name = "my-yellowtail-launch-configuration"
  image_id = data.aws_ami.amazon-linux-2.image_id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg.id]
}

# DEMO Create an autoscaling group
resource "aws_autoscaling_group" "asg" {
  name = "my-yellowtail-ASG"
  launch_configuration = aws_launch_configuration.lc.name
  min_size = 1
  desired_capacity = 3
  max_size = 5
  availability_zones = [
    "us-east-1a", "us-east-1b", "us-east-1c",
    "us-east-1d", "us-east-1e", "us-east-1f"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# DEMO Create a simple scaling policy
resource "aws_cloudwatch_metric_alarm" "gte80alarm" {
  alarm_name = "YellowTailCPUOver80PercentAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  evaluation_periods = "2"
  statistic = "Average"
  threshold = "80"
  alarm_actions = [aws_autoscaling_policy.sp1.arn]
  dimensions = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  tags = { Name = "Mod8Demo" }
}

resource "aws_cloudwatch_metric_alarm" "lte20alarm" {
  alarm_name = "YellowTailCPUUnder20PercentAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  evaluation_periods = "2"
  statistic = "Average"
  threshold = "20"
  dimensions = { AutoScalingGroupName = aws_autoscaling_group.asg.name }
  tags = { Name = "Mod8Demo" }
}

resource "aws_autoscaling_policy" "sp1" {
  name = "YellowTailSimpleScalingPolicy"
  scaling_adjustment = 2
  adjustment_type = "ChangeInCapacity"
  policy_type = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "sp2" {
  name = "YellowTailSimpleScalingPolicy2"
  scaling_adjustment = -2
  adjustment_type = "ChangeInCapacity"
  policy_type = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name
}
