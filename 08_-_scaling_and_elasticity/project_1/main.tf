terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    tls = {
      source = "hashicorp/tls"
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
  name = "web"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port      = 80
    instance_protocol  = "http"
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
  name = "webserver-cluster"
  description = "Project launch template"
  image_id = data.aws_ami.azl.id
  vpc_security_group_ids = [aws_security_group.lt_sg.id]
  instance_type = "t3.micro"
  monitoring {
    enabled = true
  }
  key_name = aws_key_pair.aws_keys.key_name
  user_data = base64encode(file("userdata.sh"))

  tags = {
    Name = var.tag
  }
}



# TODO pick up from here, check pdf for details

# Auto scaling group
####################
resource "aws_autoscaling_group" "asg" {
  name = "webserver-client"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}

