terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

variable "labname" {
  type = string
  default = "Mod8.5Project2"
  description = "A name used for the Lab = $val tag."

  validation {
    condition = length(var.labname) > 3  && can(regex("^[0-9A-Za-z\\.]+$", var.labname))
    error_message = "Must be longer than 3 characters, and only alphanumeric characters or dots. PascalCase is preferred."
  }
}

variable "prefix" {
  type = string
  default = "aurora-prod"
  description = "All resources created by this module will be be prepended with prefix, in this form: {prefix}-{resource_name}."

  validation {
    # To escape a charcter, first escape the escape character, then escape the character, like so "\\c".
    condition = length(var.prefix) > 3  && can(regex("^[-0-9A-Za-z\\.]+$", var.prefix))
    error_message = "Must be longer than 3 characters and contain only alphanumeric characters, dashes, or dots. Dash-separated words are preferred."
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Lab = var.labname
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "${var.prefix}-vpc"
  cidr = "10.0.0.0/16"

  # AZs are mapped to in order to the lists of subnets.
  # Like zip(azs, private_subnets); zip(azs, public_subnets) in python.
  azs = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.0.1.0/26", "10.0.2.0/26"]
  public_subnets  = ["10.0.3.0/25", "10.0.4.0/25"]

  # Set assign_public_ip_address = true for instances on the public subnets
  map_public_ip_on_launch = true

  # Default behaviour is one nat gateway per subnet.
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # Use an externally created eip
  external_nat_ip_ids = ["${aws_eip.nat_eip.id}"]

  # Control the default NACL associated with every subnet
  manage_default_network_acl = true
  # Use separte NACLs for the public subnets
  public_dedicated_network_acl = true
  # Use separte NACLs for the private subnets
  private_dedicated_network_acl = true

  # Names for route tables
  default_route_table_name = "${var.prefix}-default-table"
  private_route_table_tags = { "Name" = "${var.prefix}-private-route-table"}
  public_route_table_tags = { "Name" = "${var.prefix}-public-route-table"}
  # Names for subnets
  private_subnet_names = ["${var.prefix}-private-subnet-1", "${var.prefix}-private-subnet-2"]
  public_subnet_names = ["${var.prefix}-public-subnet-1", "${var.prefix}-public-subnet-2"]

  # Name for the NGW
  nat_gateway_tags = { "Name" = "${var.prefix}-nat-gateway" }
}

# Name for the IGW
resource "aws_ec2_tag" "igw_tag" {
  resource_id = module.vpc.igw_id
  key         = "Name"
  value       = "${var.prefix}-igw"
}

# Create the eip independently of the vpc module, so we can name it.
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "${var.prefix}-eip"
  }
}
