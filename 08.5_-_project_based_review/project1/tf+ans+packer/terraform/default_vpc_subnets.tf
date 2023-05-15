data "aws_vpc" "default_vpc" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.default_vpc.id}"]
  }

}
