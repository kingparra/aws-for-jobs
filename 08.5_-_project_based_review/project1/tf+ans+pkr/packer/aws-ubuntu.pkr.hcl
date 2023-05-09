packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

data "amazon-ami" "amzl" {
  filters = {
    name = "amzn2-ami-hvm-2.*-x86_64-gp2"
    root-device-type = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners = ["amazon"]
  region = "us-east-1"
}

source "amazon-ebs" "amzl" {
  source_ami = data.amazon-ami.amzl.id
  ami_name = "AmazonLinux2"
  instance_type = "t2.micro"
  ssh_username = "ec2-user"
  ssh_timeout = "5m"
  associate_public_ip_address = true
  force_delete_snapshot = true
  force_deregister = true
  temporary_iam_instance_profile_policy_document {
    Statement {
        Action   = ["s3:*", "s3-object-lambda:*"]
        Effect   = "Allow"
        Resource = ["*"]
    }
    Version = "2012-10-17"
  }
}

build {
  name = "EnergymGoldenImage"
  sources = ["source.amazon-ebs.amzl"]

  ## An example doing this with shell rather than ansible.
  ## If you uncomment this, and comment out the ansible
  ## provisioner, this packer template will still work.
  #
  # provisioner "shell" {
  #   inline = [
  #     "sudo yum install -y httpd",
  #     "sudo systemctl enable --now httpd",
  #     "sudo aws s3 sync s3://yt-websites-2023/energym-html/ /var/www/html/"
  #   ]
  # }

  provisioner "ansible" {
    user = "ec2-user"
    playbook_file = "./playbook.yml"
    use_proxy = false

    ## Workaround for bug:
    ## https://github.com/hashicorp/packer-plugin-ansible/issues/140
    extra_arguments = [
      "--ssh-extra-args",
      ## Yes, this arg is intended to be one long string.
      ## anything after the --ssh-extra-args argument
      ## gets passed verbatim to ssh, which does it's
      ## own argument parsing.
      "-o IdentitiesOnly=yes -o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedAlgorithms=+ssh-rsa"
      ]
  }
}
