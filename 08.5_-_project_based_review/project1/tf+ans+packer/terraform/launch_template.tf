# Get the most recently created AMI that we generated with Packer based on the Client tag.
data "aws_ami" "golden_image" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "tag:Client"
    values = ["Energym"]
  }
}

resource "aws_launch_template" "site_lt" {
  name = "EnergymStaticSiteLt"
  instance_type = "t2.micro"
  iam_instance_profile {
    name = aws_iam_instance_profile.EnergymInstanceProfile.name
  }
  image_id = data.aws_ami.golden_image.id
  key_name = aws_key_pair.key.key_name
  user_data = filebase64("${path.module}/user-data.sh")
  vpc_security_group_ids = [aws_security_group.static_site.id]
  tags = {
    "Name" = "EnergymStaticSite"
  }
}
