terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
/*
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
*/
  }
}


provider "random" {
  # Configuration options
}


provider "aws" {
  region                   = var.account_details.region
  shared_config_files      = var.account_details.shared_config_files
  shared_credentials_files = var.account_details.shared_credentials_files
}


/*
Tag everything with mod8_project1_${random_id}

Security group
name: web
description: "ELB for a webserver cluster"
source: anywhwere


EC2 Load balancer
lbname: web
listener configuration: HTTP
subnets in these AZs: us-east-1{a,b,c,d,e,f}
security groups: web
health check:
* ping protocol: TCP
* ping port: 80


Security group
name: webserver-cluster
description: "Webserver security group"
inbound rules:
* Allow SSH from anywhere
* Allow HTTP from anywhere


Keypair
name: YellowTailKeyPair

Launch template
name: webserver-cluster
description: "Project launch template"
ami: Latest AMZL ami
type: t3.micro
keypair: YellowTailKeyPair
Security groups: webserver-cluster
Detailed CloudWatch monitoring: Enable
Userdata: see userdata.sh
*/
