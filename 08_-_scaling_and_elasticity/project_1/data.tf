# Get the latest amazon linux ami
data "aws_ami" "azl" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


# Get instances in autoscaling group
data "aws_instances" "ins" {
  instance_tags = {
    Name = var.tag
  }
}
