terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
  }
}


provider "aws" {
  region                   = var.account_details.region
  shared_config_files      = var.account_details.shared_config_files
  shared_credentials_files = var.account_details.shared_credentials_files
}



# Elastic load balancing
########################
resource "aws_security_group" "elb_sg" {
  name        = "web"
  description = "Allow SSH traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.tag
  }
}


resource "aws_elb" "elb" {
  name               = "web"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  tags = {
    Name = var.tag
  }
}



# Launch template
#################
resource "aws_security_group" "lt_sg" {
  name        = "webserver-cluster"
  description = "Allow SSH traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = var.tag
  }
}


resource "tls_private_key" "keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "aws_keys" {
  key_name   = "YellowTailKeyPair"
  public_key = tls_private_key.keys.public_key_openssh
}


resource "aws_launch_template" "lt" {
  name                   = "webserver-cluster"
  description            = "Project launch template"
  image_id               = data.aws_ami.azl.id
  vpc_security_group_ids = [aws_security_group.lt_sg.id]
  instance_type          = "t2.micro"
  monitoring {
    enabled = true
  }
  key_name  = aws_key_pair.aws_keys.key_name
  user_data = base64encode(file("userdata.sh"))
  tags = {
    Name = var.tag
  }
}



# Auto scaling group
####################
// I can't figure out how to "Enable group metrics collection"
// for the autoscaling group.
resource "aws_autoscaling_group" "asg" {
  name = "webserver-cluster"
  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
  availability_zones = [ "us-east-1a"
                       , "us-east-1b"
                       , "us-east-1c"
                       , "us-east-1d"
                       , "us-east-1e"
                       , "us-east-1f"
                       ]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  // How do I set "Enable group metrics collection within CloudWatch"
  min_size         = 1
  desired_capacity = 1
  max_size         = 5
  tag {
    key = "Name"
    value = var.tag
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  elb                    = aws_elb.elb.id
}


resource "aws_autoscaling_policy" "sp3" {

  autoscaling_group_name = aws_autoscaling_group.asg.name
  name                   = "Project scaling policy"
  policy_type            = "PredictiveScaling"
  ##############################################################
  ## This whole block is to say "80% average cpu utilization" ##
  ##############################################################
  predictive_scaling_configuration {
    metric_specification {
      target_value = 80
      customized_load_metric_specification {
        metric_data_queries {
          id         = "load_sum"
          expression = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" ${aws_autoscaling_group.asg.name}', 'Sum', 3600))"
        }
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = aws_autoscaling_group.asg.name
              }
            }
            stat = "Average"
          }
        }
      }
      customized_capacity_metric_specification {
        metric_data_queries {
          id          = "capacity_sum"
          expression  = "SUM(SEARCH('{AWS/AutoScaling,AutoScalingGroupName} MetricName=\"GroupInServiceIntances\" my-test-asg', 'Average', 300))"
          return_data = false
        }
        metric_data_queries {
          id          = "load_sum"
          expression  = "SUM(SEARCH('{AWS/EC2,AutoScalingGroupName} MetricName=\"CPUUtilization\" my-test-asg', 'Sum', 300))"
          return_data = false
        }
        metric_data_queries {
          id         = "weighted_average"
          expression = "load_sum / capacity_sum"
        }
      }
    }
  }
}

