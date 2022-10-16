Project 4 Networking
********************
In this project, students should follow the steps
outlined below to create a custom VPC with Public
and Private Subnets, create route tables that
route traffic to an IGW or Nat Gateway depending
on whether the subnet is public or private.

Additionally, you will need to create a Bastion
Host in the Public Subnet.

As an additional challenge students will be asked
to figure out how to deploy an instance in the
Private Subnet that leverages the Bastion for
incoming SSH connections.

* Create AWS VPC (Virtual Private Cloud)
* Create Public and Private Subnets
* Create Internet Gateway (IGW)
* Create NAT Gateway
* Create NAT Gateway
* Create a Bastion host on a public subnet.


Create AWS VPC (Virtual Private Cloud)
--------------------------------------
Follow these steps to create your VPC:

Sign into the AWS Management Console
Go to the VPC Service section and select Your VPCs in the left menu.
Click Create VPC and enter the following details:

Name tag - Enter a name for the VPC (e.g. ``my-vpc``).

IPv4 CIDR block - Enter a CIDR block to specify the IP address
range available for the VPC.  If you're not sure what to put you
can enter 10.0.0.0/16 which specifies the IP address range from
10.0.0.0 to 10.0.255.255, giving your VPC up to 65,536 IP
addresses.

For more info on CIDR notation and IP addressing see https://www.digitalocean.com/community/tutorials/understanding-ip-addresses-subnets-and-cidr-notation-for-networking.

IPv6 CIDR block - No IPv6 CIDR block.

Tenancy - Default.

Click Create VPC.


Create Public and Private Subnets
---------------------------------
Next we'll create the subnets inside our VPC that will
hold our AWS resources.

Public vs Private subnets
^^^^^^^^^^^^^^^^^^^^^^^^^
Subnets can be public (accessible from the internet) or
private (not accessible from the internet), a subnet is
public when it routes traffic through an Internet
Gateway (IGW) attached the VPC.

A subnet is private when it doesn't route traffic
through an IGW, however outbound internet access can be
enabled from a private subnet by routing traffic
through a Network Address Translation (NAT) Gateway
located in a public subnet.

For more info on AWS Subnets see
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Subnets.html.

Subnets in multiple AZs
^^^^^^^^^^^^^^^^^^^^^^^
We'll create two public and two private subnets so each
subnet type can cover multiple AZs (Availability
Zones), this is required by some AWS resources (e.g.
RDS databases) and is recommended by others (e.g.
Lambda functions).

Follow these steps to create the subnets in your VPC:

* Select Subnets in the left menu.
* Click Create subnet and enter the following details:

  * VPC ID - Select the VPC you created above.

* Subnet settings - Click Add new subnet three times to
  make four new subnet forms.

  * Subnet 1 of 4 - Enter the following details:

    * Subnet name - Enter public-subnet-1
    * Availability Zone - Select the first option (e.g.
      us-east-1a)
    * Enter a CIDR block for each subnet that fits into your VPC
      CIDR block (e.g 10.0.0.0/24)

  * Subnet 2 of 4 - Enter the following details:

    * Subnet name - Enter public-subnet-2
    * Availability Zone - Select the second option
      (e.g. us-east-1b).
    * This must be in a different AZ to public-subnet-1.
    * Enter a CIDR block for each subnet that fits into
      your VPC CIDR block (e.g 10.0.1.0/24)

  * Subnet 3 of 4 - Enter the following details:

    * Subnet name - Enter private-subnet-1
    * Availability Zone - Select the first option (e.g.
      us-east-1a)
    * Enter a CIDR block for each subnet that fits into
      your VPC CIDR block (e.g 10.0.2.0/24)

  * Subnet 4 of 4 - Enter the following details:

    * Subnet name - Enter private-subnet-2
    * Availability Zone - Select the second option
      (e.g. us-east-1b).
    * This must be in a different AZ to private-subnet-1.
    * Enter a CIDR block for each subnet that fits into
      your VPC CIDR block (e.g 10.0.3.0/24)
    * Click Create subnet


Create Internet Gateway (IGW)
-----------------------------
An AWS internet gateway (IGW) is used to enable
internet access to and from subnets in your VPC. A
subnet that routes traffic to an IGW is a public
subnet, and a subnet that doesn't route traffic to an
IGW is a private subnet. Routes are configured in route
tables that we'll cover shortly.

For more on internet gateways see
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html.

Follow these steps to create an IGW and attach it to
your VPC:

* Select Internet Gateways in the left menu.
* Click Create internet gateway and enter the following
  details:
* Name tag - Enter a name for the internet gateway
  (e.g. my-internet-gateway).
* Click Create internet gateway.
* Select Actions -> Attach to VPC.
* Select the VPC you created above and click Attach internet gateway.

Then we need to attach it to our vpc:


Create NAT Gateway
------------------
A network address translation (NAT) gateway is used to provide
outbound internet access to AWS resources running in private
subnets. A NAT gateway is located in a public subnet and acts
like a proxy for outbound traffic from private subnets that route
their traffic to the NAT gateway.

For more info on NAT gateways see
https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html.

Follow these steps to create a NAT gateway in your public subnet:

* Select NAT Gateways in the left menu.
* Click Create NAT gateway and enter the following details:
* Name - Enter a name for the NAT gateway (e.g my-nat-gateway).
* Subnet - Select the subnet with the name public-subnet-1.
* Elastic IP allocation ID - Click Allocate Elastic IP to create
  a new elastic IP for the NAT gateway.
* Click Create NAT gateway.


Configure Route Tables
----------------------
Route tables are used to control where network traffic is routed
from subnets. Each VPC has one Main route table that is used by
default for any subnet that isn't explicitly associated with a
route table.

For more on AWS route tables see
https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html.

Configure VPC main route table to be private
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here we'll configure the main route table in the VPC to target
the NAT gateway to make subnets private by default.  A private
subnet is not accessible from the internet but can be given
outbound internet access via a NAT Gateway located in a public
subnet.

Follow these steps to configure the VPC main route table to be
private:

* Select Route Tables in the left menu.
* Select the main route table for the VPC you created above.
* Hover the mouse over the Name column of the selected route
  table, then click the edit icon and enter the name
  main-route-table.
* Click the Routes tab below and click Edit routes.
* Click Add route and enter the following details:
* Destination - Enter 0.0.0.0/0 to match all non-local traffic.
* Target - Select NAT Gateway then select the NAT gateway you created above.
* Click Save routes.


Create new route table for public subnets
-----------------------------------------
Here we'll create a new route table that targets the internet
gateway (IGW) that will be used by public subnets.  A public
subnet is accessible from the internet by being associated with a
route table that targets an IGW.

Follow these steps to create a route table and associate it with
public subnets:

* Click Create route table and enter the following details:

  * Name tag - Enter a name for the route table (e.g. public-route-table).
  * VPC - Select the VPC you created above.
  * Click Create then click the link displayed with the new route table ID.
  * Click the Routes tab and Edit routes.

    * Click Add route and enter the following details:
    * Destination - Enter 0.0.0.0/0 to match all non-local traffic.
    * Target - Select Internet Gateway then select the internet
      gateway you created above.

  * Click Save routes.

* Navigate back to the Route tables list and select the
  public-route-table you just created.
* Click the Subnet Associations tab and Edit subnet associations.
* Select the subnets named public-subnet-1 and public-subnet-2
  and click Save.


Create a Bastion host on a public subnet
----------------------------------------
A bastion host is typically a host that sits inside your public
subnet for the purposes of SSH (and/or RDP) access. You can
think of it as a host for gaining secure access to resources in
your VPC from the public internet. Bastion hosts are sometimes
referred to as jump servers, as you jump to one, then back out of
it.

In this Project Step, you will create an EC2 instance that will
serve as both an observer instance that you can run various tests
from and a bastion host.

Note: Once you access a bastion host (for example, by using SSH
to log into it), in order to access other instances you must
either setup SSH port forwarding, or copy your SSH key material
to the bastion host. The latter is not ideal for security reasons
in a production environment. If you require Windows connectivity,
then setting up Remote Desktop Gateway instead of SSH port
forwarding is recommended.  This Project Step assumes SSH
connectivity to Linux instances.

Instructions
^^^^^^^^^^^^
Navigate to the EC2 Dashboard and click Launch Instance.
A 7-page wizard starts. Fill out accordingly:

Step 1: Choose AMI
* Select the top entry for the Amazon Linux 2 AMI (64-bit)

Step 2: Choose Instance Type
* Select the default t2.micro (Free tier eligible)

Step 3: Configure Instance
* Network: Select the my-vpc
* Subnet: Select the public-subnet-1 (us-east-1a) subnet
* Auto-assign Public IP: Select Enable
* IAM role: Leave as None
* Note: Leave the rest of the settings at their default values

Step 4: Add Storage
* Leave all the default values

Step 5: Add Tags
* No tags are needed

Step 6: Configure Security Group
* Select Create a new security group
* Security group name: Enter SG-bastion
* Description: Enter SG for bastion host. SSH access only.
* Rule:

   * Type: SSH
   * Protocol: TCP
   * Port: 22
   * Source: Select My IP from the drop-down menu (Note: This is
     a safe, temporary setting and will get changed later.)


Step 7: Review
• Review the settings and click Launch when ready.


Select an existing key pair or create a new key pair dialog:

* Choose Create a new key pair (This key pair is used to SSH into
  your instance)
* Give it the name YellowTailKeyPair (Note that a file with
  extension .pem will download to your computer.  If you are
  using macOS, this type of file will work fine, but if you are
  using Windows, you will need to download PuTTY and convert the
  key to extension .ppk (PuTTy Private Key)

Click Launch Instance when ready to proceed.
2. Once launched, click View Instances to see your instance in the EC2 Dashboard.
3. Hover over the Name field of your instance. Click the edit pencil and enter bastion for the Name.
This will make it easily identifiable when other instances are up and running as well:


Summary
-------
In this Project Step you launched a basic Linux EC2 instance with
a publicly routable IP address in your public subnet that will be
used as a bastion host. Later on, you will modify its security
group to restrict inbound traffic to SSH only.

In production you would restrict inbound access to specific IP
addresses of your network administrators. (In this Project, you
will be a bit more relaxed, however.) The outbound traffic will
also be modified later, restricting the destination to the
security group of instance(s) in your private subnet only. When
configuring bastion hosts, they are often stripped down to
provide the minimal amount of services. Essentially, they are
used for SSH almost exclusively, so with fewer services there are
fewer exploit possibilities.


Challenge: Launching an EC2 Instance on a Private Subnet
--------------------------------------------------------
Go ahead and create an EC2 instance on one of your private
subnets. Once you have created EC2 instances in both Public and
Private subnets, you can connect to the bastion host (EC2
instance in the Public subnet) through SSH using putty (any
terminal of your choice).

To be able to do this you will need to create a Security Group
that allows traffic on port 22 and that references the
SG-bastion.

Next you will SSH into your bastion host, and enable ssh agent
forwarding so you can SSH (jump) to the private instance in your
private subnet. The instructions below assume your local machine
is Linux or Windows. However, you could use an SSH client such
as PuTTY.
