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
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "random" {}

provider "tls" {}

resource "random_pet" "session_name" {
  prefix = "session-name"
  length = 7
}

provider "aws" {
  shared_config_files = ["/home/chris/.aws/config"]
  shared_credentials_files = ["/home/chris/.aws/credentials"]
  profile = "default"
  region = "us-east-1"
  default_tags {
    tags = {
      AfjModule = "4"
      AssignmentName = "publuc_and_private_subnets_in_a_vpc"
#      SessionName = random_pet.session_name.id
    }
  }
}
# }}}

# Network topology {{{
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "lab_vpc" }
}



resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"
  tags = { Name = "lab_public_subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "lab_public_rt" }
}

resource "aws_route" "igw_route" {
  # Match all non-local traffic in the public subnet
  # and send it to the igw
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_assoc" {
  # Subnetes have to explicitly be associated with this
  # route table to be public.
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
  tags = { Name = "lab_private_subnet" }
}

resource "aws_default_route_table" "main_rt" {
  # This resource mutates the main route table
  # to forward all non-local traffic to the ngw.
  # There is a route not shown here that takes
  # care of local traffic. 10.0.0.0/16 local
  default_route_table_id = aws_vpc.lab_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "lab_igw" }
}

resource "aws_nat_gateway" "ngw" {
  # The idea of sending private traffic through the ngw
  # is to allow internet access, but mask the addresses
  # of the hosts within the nat.
  connectivity_type = "public"
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id
  depends_on = [aws_internet_gateway.igw]
  tags = { Name = "lab_ngw" }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
  tags = { Name = "lab_eip" }
}
# }}}

# Keypair {{{
resource "tls_private_key" "key_contents" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "key_object" {
  key_name = "lab1key_${random_pet.session_name.id}"
  public_key = tls_private_key.key_contents.public_key_openssh
}
# }}}

# AMI lookup {{{
data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# }}}

# Security groups {{{
resource "aws_security_group" "public_instance_sg" {
  name        = "allow_http_ssh_public"
  description = "Allow all ssh inbound traffic"
  vpc_id = aws_vpc.lab_vpc.id
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

resource "aws_security_group" "private_instance_sg" {
  name        = "allow_http_ssh_private"
  description = "Allow ssh inbound traffic from "
  vpc_id = aws_vpc.lab_vpc.id
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
# }}}

# Instances {{{
resource "aws_instance" "public_instance" {
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.public_instance_sg.id]
  subnet_id = aws_subnet.public_subnet.id
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.key_object.key_name
  tags = { Name = "lab_puclic_instance" }
}

resource "aws_instance" "private_instance" {
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  subnet_id = aws_subnet.private_subnet.id
  key_name = aws_key_pair.key_object.key_name
  availability_zone = "us-east-1b"
  tags = { Name = "lab_private_instance" }
}
# }}}

# Outputs {{{
output "private_key" {
  value = tls_private_key.key_contents.private_key_openssh
  sensitive = true
}

output "public_instance_ip" {
  value = aws_instance.public_instance.public_ip
}

data "aws_instance" "private_instance_facts" {
  instance_id = aws_instance.private_instance.id
}

output "private_instance_ip" {
  value = data.aws_instance.private_instance_facts.private_ip
}

output "session_name" {
  value = random_pet.session_name.id
}

output "default_route_table_id" {
  value = aws_vpc.lab_vpc.default_route_table_id
}
# }}}
