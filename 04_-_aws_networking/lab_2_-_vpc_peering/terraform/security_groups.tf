module "vpc_a_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name = "vpc_a_instance_sg"
  description = "Allow SSH ingress from my ip"
  vpc_id = module.vpc_a.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp","all-icmp"]
  egress_rules = ["all-all"]
}

module "vpc_b_instance_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name = "vpc_b_instance_sg"
  description = "Allow SSH ingress from anywhere"
  vpc_id = module.vpc_b.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp","all-icmp"]
  egress_rules = ["all-all"]
}
