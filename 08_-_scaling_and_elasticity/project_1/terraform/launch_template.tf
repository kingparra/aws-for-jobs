resource "aws_security_group" "lt_sg" {
  name = "webserver-cluster"
  description = "Allow SSH traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "azl" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "tls_private_key" "keys" {
  algorithm = "ED25519"
}


resource "aws_key_pair" "aws_keys" {
  key_name = "YellowTailKeyPair"
  public_key = tls_private_key.keys.public_key_openssh
}


resource "aws_launch_template" "lt" {
  name = "webserver-cluster"
  description = "Project launch template"
  image_id = data.aws_ami.azl.id
  vpc_security_group_ids = [aws_security_group.lt_sg.id]
  instance_type = "t2.micro"
  monitoring {
    # detailed monitoring
    enabled = true
  }
  key_name  = aws_key_pair.aws_keys.key_name
  user_data = filebase64("${path.module}/userdata.sh")
}
