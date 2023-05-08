my-vpc 10.0.0.0/16
public-subnet-1 us-east-1a 10.0.0.0/24
public-subnet-2 us-east-1b 10.0.1.0/24
private-subnet-1 us-east-1a 10.0.2.0/24
private-subnet-2 us-east-1b 10.0.3.0/24
my-internet-gateway my-vpc
my-nat-gateway public-subnet-1 allocate a new EIP
[edit] main-route-table 0.0.0.0/0 my-nat-gateway
public-route-table associate with [public-subnet-1, public-subnet-2]
public-route-table my-vpc 0.0.0.0/0 my-internet-gateway
bastion-host amazon-linux-2-ami t2.micro my-vpc public-subnet-1 auto_assign_puclic_ip=true SG-bastion YellowTailKeyPair
backend-host amazon-linux-2-ami t2.micro my-vpc private-subnet-1 auto_assign_puclic_ip=true SG-backend YellowTailKeyPair
wget $key && mv $key ~/.ssh && chmod 0600 ~/.ssh/$key
ssh -AJ ec2-user@$bastion_host_ip ec2-user@$backend_host_ip 'sudo yum update -y'
