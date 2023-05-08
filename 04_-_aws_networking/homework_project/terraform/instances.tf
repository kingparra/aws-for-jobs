resource "aws_instance" "public_instance" {
  tags = { Name = "hw_public_instance" }
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [module.public_instance_sg.security_group_id]
  subnet_id = aws_subnet.public_subnet_1.id
  availability_zone = "us-east-1a"
  key_name = aws_key_pair.key_object.key_name
}

resource "aws_instance" "private_instance" {
  tags = { Name = "hw_private_instance" }
  ami = data.aws_ami.amzlinux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.private_instance_sg.security_group_id]
  subnet_id = aws_subnet.private_subnet_1.id
  key_name = aws_key_pair.key_object.key_name
  availability_zone = "us-east-1a"
}
