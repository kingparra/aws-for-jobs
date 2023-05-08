# The more control you need, the less you can abstract away.
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = { Name = "my-vpc" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "public-route-table" }
}

resource "aws_route" "igw_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_1_assoc" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_2_assoc" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.0.0/24"
  tags = { Name = "public-subnet-1" }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
  tags = { Name = "public-subnet-2" }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.2.0/24"
  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.lab_vpc.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.3.0/24"
  tags = { Name = "private-subnet-2" }
}

resource "aws_default_route_table" "main_rt" {
  # This resource mutates the main route table
  # to forward all non-local traffic to the ngw.
  # There is a route not shown here that takes
  # care of local traffic. 10.0.0.0/16 local
  default_route_table_id = aws_vpc.lab_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = { Name = "main-route-table" }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab_vpc.id
  tags = { Name = "my-internet-gateway" }
}

resource "aws_nat_gateway" "ngw" {
  # The idea of sending private traffic through the ngw
  # is to allow internet access, but mask the addresses
  # of the hosts within the nat.
  connectivity_type = "public"
  subnet_id = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.nat_eip.id
  tags = { Name = "my-nat-gateway" }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = { Name = "my-eip" }
}
