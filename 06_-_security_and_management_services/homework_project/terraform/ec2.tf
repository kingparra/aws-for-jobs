data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

resource "aws_security_group" "instance_sg" {
  name = "instance_sg"
  description = "Allow HTTP/S and SSH ingress"
  ingress {
    description = "SSH ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    description = "Allow HTTP ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  ingress {
    description = "Allow HTTPS ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.latest_amazon_linux.id
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.s3_access_instance_profile.name
  user_data = <<-EOF
    #!/bin/bash
    sudo yum install -y awscli httpd
    sudo systemctl enable --now httpd
    sudo aws s3 cp s3://${aws_s3_bucket.bucket.name} /var/www/html --recursive
  EOF
}
