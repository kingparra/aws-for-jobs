terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.54.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "tls" {}

provider "aws" {
  shared_config_files = ["/home/chris/.aws/config"]
  shared_credentials_files = ["/home/chris/.aws/credentials"]
  profile = "default"
  region = "us-east-1"
    default_tags {
      tags = {
        AssignmentNumber = "1"
        AssignmentName = "deploy and instance"
        Module = "3"
    }
  }
}

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow http and ssh inbound traffic"
  ingress {
    description = "HTTP from anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description = "SSH from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "tls_private_key" "key_contents" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_object" {
  key_name = "lab1key"
  public_key = tls_private_key.key_contents.public_key_openssh
}

data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "i" {
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.allow_http_ssh.name]
  user_data = file("${path.module}/user-data.bash")
  key_name = aws_key_pair.key_object.key_name
}

output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "ip" {
  value = aws_instance.i.public_ip
}
