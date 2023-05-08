module "vpc_a" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc_a"
  version = "3.19.0"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a"]
  public_subnets = ["10.0.0.0/24"]
  public_subnet_names = ["vpc_a_public_subnet"]
  create_igw = true
  igw_tags = {"Name": "vpc_a_igw"}
}

module "vpc_b" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc_b"
  version = "3.19.0"
  cidr = "20.0.0.0/16"
  azs = ["us-east-1b"]
  public_subnets = ["20.0.0.0/24"]
  public_subnet_names = ["vpc_b_public_subnet"]
  create_igw = true
  igw_tags = {"Name": "vpc_b_igw"}
}
