/* TODO Get this working. InvalidSubnetConflict CIDR
 *
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-vpc"
  cidr = "10.0.0.0/16"

  # AZs are mapped to in order to the lists of subnets.
  # Like zip(azs, private_subnets); zip(azs, public_subnets) in python.
  azs = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.0.1.0/26", "10.0.2.0/26"]
  public_subnets  = ["10.0.3.0/25", "10.0.3.0/25"]

  # Default behaviour is one nat gateway per subnet.
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # Control the default NACL associated with every subnet
  # manage_default_network_acl = true
  # Use separte NACLs for the public subnets
  public_dedicated_network_acl = true
  # Use separte NACLs for the private subnets
  private_dedicated_network_acl = true

  # Names for route tables
  default_route_table_name = "${local.prefix}-default-table"
  private_route_table_tags = { "Name" = "${local.prefix}-private-route-table"}
  public_route_table_tags = { "Name" = "${local.prefix}-public-route-table"}
  # Names for subnets
  private_subnet_names = ["${local.prefix}-private-subnet-1", "${local.prefix}-private-subnet-2"]
  public_subnet_names = ["${local.prefix}-public-subnet-1", "${local.prefix}-public-subnet-2"]

  # Name for the NGW
  nat_gateway_tags = { "Name" = "${local.prefix}-nat-gateway" }
  # TODO Name for the IGW
}

locals {
  prefix = "aurora-prod"
}
*/
