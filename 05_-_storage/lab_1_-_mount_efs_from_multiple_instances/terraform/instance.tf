resource "aws_instance" "nfs_client_1" {
  tags                        = { Name = "nfs-client-1" }
  ami                         = data.aws_ami.amzlinux.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = aws_key_pair.key_object.key_name
  vpc_security_group_ids      = [module.nfs_client_1_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  user_data                   = templatefile("user-data.tftpl",
                                             {fs_id = aws_efs_file_system.fs.id })
  metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
}

resource "aws_instance" "nfs_client_2" {
  tags                        = { Name = "nfs-client-2" }
  ami                         = data.aws_ami.amzlinux.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name = aws_key_pair.key_object.key_name
  vpc_security_group_ids      = [module.nfs_client_2_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[1]
  user_data                   = templatefile("user-data.tftpl", {fs_id = aws_efs_file_system.fs.id })
    metadata_options {
    http_endpoint = "enabled"
    instance_metadata_tags = "enabled"
  }
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
}

