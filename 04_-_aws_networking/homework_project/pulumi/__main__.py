import pulumi
import pulumi_aws as aws
import requests
import json

config = pulumi.Config()

latest_amazon_linux_ami = \
  aws.ec2.get_ami(
    filters=[aws.ec2.GetAmiFilterArgs(name="name", values=["amzn2-ami-hvm-*"])],
    owners=["amazon"], most_recent=True).id

vpc = aws.ec2.Vpc("my-vpc",
  cidr_block="10.0.0.0/16", enable_dns_hostnames=True, enable_dns_support=True)

igw = aws.ec2.InternetGateway("my-internet-gateway", vpc_id=vpc.id)

public_subnet_1 = aws.ec2.Subnet("public-subnet-1",
  vpc_id=vpc.id, cidr_block="10.0.0.0/24", availability_zone="us-east-1a",
  map_public_ip_on_launch=True)
public_subnet_2 = aws.ec2.Subnet("public-subnet-2",
  vpc_id=vpc.id, cidr_block="10.0.1.0/24", availability_zone="us-east-1b",
  map_public_ip_on_launch=True)
private_subnet_1 = aws.ec2.Subnet("private-subnet-1",
  vpc_id=vpc.id, cidr_block="10.0.2.0/24", availability_zone="us-east-1a")
private_subnet_2 = aws.ec2.Subnet("private-subnet-2",
  vpc_id=vpc.id, cidr_block="10.0.3.0/24", availability_zone="us-east-1b")

public_route_table = aws.ec2.RouteTable("public-route-table",
  vpc_id=vpc.id,
  routes=[aws.ec2.RouteTableRouteArgs(
    cidr_block="0.0.0.0/0", gateway_id=igw.id)])

public_subnet_1_rta = aws.ec2.RouteTableAssociation(
  "public-subnet-1-rta",
  subnet_id=public_subnet_1.id,
  route_table_id=public_route_table.id)

public_subnet_2_rta = aws.ec2.RouteTableAssociation(
  "public-subnet-2-rta",
  subnet_id=public_subnet_2.id,
  route_table_id=public_route_table.id)

main_route_table_name = aws.ec2.Tag(
  "main-route-table-name",
  resource_id=vpc.default_route_table_id,
  key="Name",
  value="main-route-table")

eip = aws.ec2.Eip("my-eip", vpc=True)

ngw = aws.ec2.NatGateway("my-nat-gateway",
  allocation_id=eip.allocation_id,
  subnet_id=public_subnet_1.id,
  tags={"Name": "my-nat-gateway"})

route_to_ngw = aws.ec2.Route("route-to-ngw",
  destination_cidr_block="0.0.0.0/0",
  nat_gateway_id=ngw.id,
  route_table_id=vpc.default_route_table_id)

def getmyip():
    endpoint = "https://ipinfo.io/json"
    response = requests.get(endpoint, verify = True)
    if response.status_code != 200:
      return 'Status:', response.status_code, 'Problem with the request. Exiting.'
      exit()
    data = response.json()
    return data['ip']

sg_bastion = aws.ec2.SecurityGroup("SG-bastion",
    description="SSH access from my ip address",
    vpc_id=vpc.id,
    ingress=[aws.ec2.SecurityGroupIngressArgs(
      from_port=22, to_port=22, protocol="tcp", cidr_blocks=[getmyip() + "/32"],)],
    egress=[aws.ec2.SecurityGroupEgressArgs(
      from_port=0, to_port=0, protocol="-1", cidr_blocks=["0.0.0.0/0"],)]
    )

sg_backend = aws.ec2.SecurityGroup("SG-backend",
    description="SSH access from my anywhere",
    vpc_id=vpc.id,
    ingress=[aws.ec2.SecurityGroupIngressArgs(
      from_port=22, to_port=22, protocol="tcp", cidr_blocks=["0.0.0.0/0"],)],
    egress=[aws.ec2.SecurityGroupEgressArgs(
      from_port=0, to_port=0, protocol="-1", cidr_blocks=["0.0.0.0/0"],)]
    )

# The keypair name is hardcoded to an existing one for now.
bastion_host = aws.ec2.Instance("bastion-host",
    instance_type="t2.micro",
    subnet_id=public_subnet_1.id,
    vpc_security_group_ids=[sg_bastion.id],
    ami=latest_amazon_linux_ami,
    key_name="demo-kp",
    tags={"Name": "bastion-host"})

backend_host = aws.ec2.Instance("backend-host",
    instance_type="t2.micro",
    subnet_id=private_subnet_1.id,
    vpc_security_group_ids=[sg_backend.id],
    ami=latest_amazon_linux_ami,
    key_name="demo-kp",
    tags={"Name": "backend-host"})

pulumi.export("bastion-host-public-ip", bastion_host.public_ip)
pulumi.export("backend-host-private-ip", bastion_host.private_ip)
