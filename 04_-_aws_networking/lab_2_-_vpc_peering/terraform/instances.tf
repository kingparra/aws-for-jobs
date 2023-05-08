resource "aws_instance" "vpc_a_instance" {
  tags = { Name = "vpc_a_instance" }
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.vpc_a_instance_sg.security_group_id]
  subnet_id = module.vpc_a.public_subnets[0]
  # availability_zone = "us-east-1a"
  key_name = aws_key_pair.key_object.key_name
}

resource "aws_instance" "vpc_b_instance" {
  tags = { Name = "vpc_b_instance" }
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.vpc_b_instance_sg.security_group_id]
  subnet_id = module.vpc_b.public_subnets[0]
  # availability_zone = "us-east-1a"
  key_name = aws_key_pair.key_object.key_name
}
