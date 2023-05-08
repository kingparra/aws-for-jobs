# This file is known as a *packer template*. A configuration
# file that defines the image you want to build and how to
# build it.

# Contains packer settings, including specifying a required packer version.
packer {
  # Plugins required by the template to build your image.
  required_plugins {
    amazon = {
      # Each plugin block contains a version and source attribute.
      version = ">= 0.0.2"
      source = "github.com/hashicorp/amazon"
    }
  }
}

# This block configures a specifi builder plugin, which is then invoked by a build block.
# Source blocks use *builders* and *communicators* to define what kind of virtualization to use, how to launch the image you want to provision, and how to connect to it.
#      builder type   name
#       vvvvvvvvvv   vvvvvv
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
# The build block defines what packer should do with the ec2 instance after it launches. The artifact that results from the build step is not managed by packer, you have to delete the
build {
  name = "learn-packer-ckingparra"
  sources = ["source.amazon-ebs.ubuntu"]
  # Here's where the magic happens.
  # You can have multiple provisioner blocks. Provisioners run in the order they're declared.
/*   provisioner "ansible" {
    playbook_file = "./playbook.yml"
  } */
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
    # ansible_env_vars
    # extra_aruments
    # user
    playbook_file = "./playbook.yml"
  }
  /* You can use the only or except configurations to run a provisioner only with specific sources. These two configurations do what you expect: only will only run the provisioner on the specified sources and except will run the provisioner on anything other than the specified sources. */
}

