terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    # To generate the ssh kepair
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.3"
    }
    # To download the website site content
    http = {
      source = "hashicorp/http"
      version = "3.2.0"
    }
    # To name the bucket
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "aws" {
  region                   = var.account_details.region
  shared_config_files      = var.account_details.shared_config_files
  shared_credentials_files = var.account_details.shared_credentials_files
  default_tags {
    tags = {
      Lab = "midterm_project_1"
      Session = "1"
    }
  }
}

# Prerequistes
resource "random_pet" "webapp_bucket_petname" {
  keepers = {
    # Generate a new pet name each time we switch to a vpc id
    bucket_id = aws_vpc.vpc.id
  }
}

resource "aws_s3_bucket" "webapp_bucket" {
  bucket = random_pet.webapp_bucket_petname.id
}

resource "aws_s3_object" "webapp_bucket_object" {
  bucket = aws_s3_bucket.webapp_bucket.id
  key = "samplepage.php"
  content = data.http.sample_page_contents.response_body
}

resource "aws_iam_role" "webapp_role" {
  name = "midterm-ec2-s3-role"
  # In order to assume the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  role = aws_iam_role.webapp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_eip" "eip" {
  # This will be associated with the nat gateway
}


# Create a vpc with private and public subnets
# see networking.tf


# Create a vpc security group for a public web server
resource "aws_security_group" "webserver_sg" {
    name        = "tutorial-securitygroup"
    description = "Tutorial Security Group"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Create a vpc security group for a private DB instance
resource "aws_security_group" "db-sg" {
    name        = "tutorial-db-securitygroup"
    description = "Tutorial DB Instance Security Group"
    vpc_id      = aws_vpc.vpc.id
    ingress {
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.webserver_sg.id]
        self            = false
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Create a DB subnet group
resource "aws_db_subnet_group" "dsg" {
  name = "tutorial-db-subnet-group"
  description = "Tutorial DB Subnet Group"
  # vpc: "midterm-vpc" (vpc-identifier)
  # availability_zones = ["us-east-1a", "us-east-1b"]
  subnet_ids = [ aws_subnet.subnet-023f4bbe3d8e5dac8-midterm-subnet-private2-us-east-1b.id, aws_subnet.subnet-00e517c733f3793c7-midterm-subnet-private1-us-east-1a.id]
}


# Now lets create a DB instance
##################################################################################
# resource: rds database
# ^^^^^^^^^^^^^^^^^^^^^^
# engine type: mysql
# version: 5.7.38
# templates: free tier
# instance identifier – tutorial-db-instance
# Master username – tutorial_user
# Auto generate a password – Disable the option.
# Master password – Choose a password.
# instance configuration:
#   "include previous generation classes"
#   "burstable classes"
# storage and availability and durability sections:
#   storaget type: gp2
#   allocated storage: 20GiB
#   disable storage autoscaling
# networking
#   type: IPv4
#   vpc: aws_vpc.vpc.id
#
# existing vpc sgs: tutorial-db-securitygroup
#
# database authentication
#  password authentication
#
# additional configuration
#  initial db name: midtermdb

# output
# ^^^^^^
# rds database endpoint
# rds database endpoint port


# Now create an ec2 instance and install a web server
##################################################################################


# Connect your apache web server to your db instance
##################################################################################
