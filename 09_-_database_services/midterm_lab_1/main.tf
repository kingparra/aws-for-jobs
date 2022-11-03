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
    http = {
      source = "hashicorp/http"
      version = "3.2.0"
    }
  }
}

provider "aws" {
  region                   = var.account_details.region
  shared_config_files      = var.account_details.shared_config_files
  shared_credentials_files = var.account_details.shared_credentials_files
  default_tags {
    tags = {
      Name = "midterm_project_1"
      Session = "1"
    }
  }
}

# Prerequistes
#################################################################################################
resource "aws_s3_bucket" "webapp_bucket" {
  bucket = "webapp-bucket-ergo-proxy-relevent-beaver"
}

resource "aws_s3_object" "sample_page_object" {
  bucket = aws_s3_bucket.webapp_bucket.id
  key = "samplepage.php"
  content = data.http.sample_page_contents.response_body
}

/*
resource "aws_iam_role" "webapp_role" {
  # policy AmazonS3FullAccess
  name = "midterm-ec2-s3-role"
}

resource "aws_eip" "eip" {
  # region = "us_east_1" # north virginia
}
*/

# Create a vpc with private and public subnets
#################################################################################################
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  # region = "us_east_1" # north virginia
  # name = "midterm"
  # Name tag auto-generation: midterm
  # number of AZs: 2
  # AZs: us-east-1a, us-east-1b
  # number of public subnets: 2
  # number of private subnets: 2
  #  Public subnet CIDR block in us-east-1a: 10.0.0.0/24
  #  Public subnet CIDR block in us-east-1b 10.0.1.0/245.
  #  Private subnet CIDR block in us-east-1a: 10.0.2.0/24
  #  Private subnet CIDR block in us-east-1b 10.0.3.0/24
  # NGW: In 1 AZ
  # VPC endpoints: None
  # Enable DNS hostnames: yes
  # Enable DNS resolution: yes
}

/*
resource "aws_internet_gateway" "igw" {
}


# Create a vpc security group for a public web server
#################################################################################################
resource "aws_security_group" "public_subnet_sg" {
  name        = "web"
  description = "ELB for a webserver cluster"
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
}

resource "aws_subnet" "public_subnet" {
}


# Create a vpc security group for a private DB instance
#################################################################################################
resource "aws_security_group" "private_subnet_sg" {
  name        = "web"
  description = "ELB for a webserver cluster"
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
}

resource "aws_subnet" "private_subnet" {
}


# Create a DB subnet group
#################################################################################################
resource "aws_db_subnet_group" "dsg" {
  name = "tutorial-db-subnet-group"
  description = "Tutorial DB Subnet Group"
  # vpc: "midterm-vpc" (vpc-identifier)
  # availability_zones = ["us-east-1a", "us-east-1b"]
  # subnets = [aws_subnet.public_subnet.public_subnet_sg.id, aws_subnet.private_subnet.private_subnet_sg.id]

}


# Now lets create a DB instance
#################################################################################################
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
#################################################################################################


# Connect your apache web server to your db instance
#################################################################################################

*/
