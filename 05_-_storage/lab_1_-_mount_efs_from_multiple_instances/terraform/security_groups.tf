module "nfs_client_1_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "nfs-client-1-sg"
  description = "Security group for EBS clients"

  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp","nfs-tcp"]
  egress_rules = ["all-all"]
}

module "nfs_client_2_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"

  name = "nfs-client-2-sg"
  description = "Security group for EBS clients"

  vpc_id = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp","nfs-tcp"]
  egress_rules = ["all-all"]
}
