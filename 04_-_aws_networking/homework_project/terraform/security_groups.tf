module "public_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "SG-bastion"
  description = "Allow SSH ingress from my ip"

  vpc_id = aws_vpc.lab_vpc.id
  ingress_cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]
}

module "private_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "SG-backend"
  description = "Allow SSH ingress from anywhere"

  vpc_id = aws_vpc.lab_vpc.id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]
  egress_rules = ["all-all"]
}
