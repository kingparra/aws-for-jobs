data "http" "myip" {
  url = "https://ipv4.icanhazip.com/"
}

data "aws_ami" "amzlinux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_instance" "private_instance_facts" {
  instance_id = aws_instance.private_instance.id
}
