packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name = "learn-packer-linux-aws-kingparrac-4"
  instance_type = "t2.micro"
  region = "us-east-1"
  profile = "personal"
  source_ami_filter {
    filters = {
      name = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

variable "foo" {
  default = "bar"
}

build {
  name = "learn-packer-ckingparra"
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
  provisioner "shell" {
    inline = [
      "echo provisioning all the things",
      "echo the value of 'foo' is '${var.foo}'",
    ]
  }
  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}

