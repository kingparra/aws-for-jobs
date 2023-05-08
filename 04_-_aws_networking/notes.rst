*******************************
 Module 4: Networking Services
*******************************


Learning objectives
-------------------
* Review of basic network concepts
* An overview of the VPC service
* VPC subnetting
* Public and private subnet use cases
* NACLs
* VPC service limits
* VPC deployment startegies
* VPC peering
* Site-to-site VPN
* Direct connect


OSI Model
---------
Physical, data-link, network, transport, session, presentation, application.


VPC
---
A VPC is a logically isolated virtual network. Think of it as your very own LAN in the cloud. In
order for two VPCs to communicate, they must be inter-networked with a gateway. VPCs belong to an
account. They are local to a single region, but but can span multiple AZs.

VPCs give you control over

* IP address ranges
* subnets
* gateways
* route tables
* network ACLs (NACLs)

IP Addressing
^^^^^^^^^^^^^
* Parameters required to create a VPC

  * CIDR block (a range of IPv4 addresses)

    * Cannot be change after you create a VPC
    * The largest IPv4 block size is /16
    * The smallest IPv4 CIDR block size is /28
    * IPv6 is also supported with a different block size limit
    * CIDR blocks of subnets cannot overlap

  * Terraform arguments https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc

Reserved IP Addresses
^^^^^^^^^^^^^^^^^^^^^
There are five reserved IP addresses for every VPC.

+-----------+------------------------------------------+
| Address   | Purpose                                  |
+===========+==========================================+
| ``*.0``   | Network address                          |
+-----------+------------------------------------------+
| ``*.1``   | VPC router                               |
+-----------+------------------------------------------+
| ``*.2``   | DNS server                               |
+-----------+------------------------------------------+
| ``*.3``   | Reserved by AWS for future use           |
+-----------+------------------------------------------+
| ``*.255`` | Network broadcast address;               |
|           | AWS doesn't support broadcast in a VPC.  |
+-----------+------------------------------------------+

VPC Use Cases
^^^^^^^^^^^^^
Some VPC uses cases include...

* Host a simple internet facing website
* Host multi-tier web apps
* Disaster recovery
* For extension of the on-prem network into the cloud
* Inspection of out-of-band and inline traffic


VPC Subnetting
--------------

Subnets: Dividing your VPC
^^^^^^^^^^^^^^^^^^^^^^^^^^
A subnet is a portion of your VPCs IP address range where resource can be placed.
Subnets are not isolation boundaries.
Subnets represent a subset of the VPC CIDR block.
The CIDR blocks of subnets cannot overlap.
Each subnet resides completely within one AZ.
One or more subnets can be added in each AZ or in a local zone.
Subnets are classified as public or private.
AWS reserves five IP addresses in each subnet.

Subnet Use Cases
^^^^^^^^^^^^^^^^
Instances to store data: Private subnet.

Instances for backend services: Private subnet.

Instances for batch processing: Private subnet.

Instance to host web applications: Public or private subnet.


Subnet Demo
-----------

Route tables and routes
-----------------------

Route tables and routes
^^^^^^^^^^^^^^^^^^^^^^^
A route table contains a set of rules (or routes) that
you can configure to redirect network traffic from the
subnet.

Each route specifies a destination and a target.

By default, every route table contains a local route
for communication within the VPC.

Each subnet must be associated with a route table (at
most one).

Internet Gateway (IGW)
^^^^^^^^^^^^^^^^^^^^^^
A gateway (router) between a VPC and the internet.
Attached to a VPC. Has a route table.

NAT Gateway (NGW)
^^^^^^^^^^^^^^^^^

Route Table Demo
----------------

Public IP Address Types
-----------------------

Public IP Address Types
^^^^^^^^^^^^^^^^^^^^^^^
Public IPv4 addresses:
* Automatically assigned through the "auto-assign
  public IP address" setting at the subnet level or
  enabled at launch.

Elastic IP address (EIP):
* Associated with an account
* Can be attached to any instance or elastic network interface (ENI).
* Can be allocated and remapped anytime.

Elastic Network Interface
^^^^^^^^^^^^^^^^^^^^^^^^^
An elastic network interface (ENI) is a virtual network interface (vNIC) that you can:
* attach to an instance;
* Detach from an instance, and attach to another instance to redirect network traffic.

The ENIs attributes follow when it is reattached to a
new instance. (What is an attribute?)

Each instance in your VPC has s default network
interface that is assigned a private IPv4 address from
the IPv4 adddress range of your VPC.


Network security
----------------

Network security
^^^^^^^^^^^^^^^^
* Security groups (SGs)
* Network Access Control Lists (NACLs)
* Flow Logs
* Route Tables (RTs)
* Subnets

What is a NACL?
^^^^^^^^^^^^^^^
A NACL is like a stateless firewall at the subnet level. Every subnet is associated with a NACL.

From "Network ACL Basics" https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html

"A network ACL has inbound rules and outbound rules. Each rule can either allow or deny traffic.
Each rule has a number from 1 to 32766. We evaluate the rules in order, starting with the lowest
numbered rule, when deciding whether allow or deny traffic. If the traffic matches a rule, the rule
is applied and we do not evaluate any additional rules. We recommend that you start by creating
rules in increments (for example, increments of 10 or 100) so that you can insert new rules later
on, if needed."

"We evaluate the network ACL rules when traffic enters and leaves the subnet, not as it is routed
within a subnet."

Default NACLs
^^^^^^^^^^^^^
A network ACL has separate inbound and outbound rules
that can either allow or deny traffic.

Default network ACLs allow all inbound and outbound
IPv4 traffic.

Custom network ACLs
^^^^^^^^^^^^^^^^^^^
By default custom NACLs deny all inbound and outbound
traffic until you add new rules.

Network ACLs are stateless.

Both allow and deny rules can be specified by you.

Starting with the lowest number, rules are evaluated in
number order.

Need to allow outbound response traffic on ephemeral
ports (1024-65535).


NACLs Demo
----------


Types of VPC
------------

VPC Types
^^^^^^^^^
The following are the types of VPCs:
* Default VPC: It gets automatically created in every
  region when your AWS account is created.
* Custom VPC: This type of vpc is created by the user.

Default VPC
* Comes with a default subnet in each AZ
* Comes with a default CIDR ``172.31.0.0/16``
* Includes an internet gateway (IGW).
* Allows users to

   * Add additional non-default subnets
   * Modify the main route table
   * Add additional route tables
   * Associate additional security groups
   * Update the rules of the default security groups
   * Add site-to-site vpc connections
   * Add more IPv4 CIDR blocks
   * Access VPCs in a remote region by using a direct connect gateway.


VPC Deployment Options
----------------------

Single VPC Deployment
^^^^^^^^^^^^^^^^^^^^^
There are limited cases where deploying one VPC might be appropriate:

* Small, single application managed by a small team.
* High performance computing (HPC).
* Identity management.

For most use cases, there are two primary patterns for
organizing your infrastructure: multi-vpc and multi-account.

Multiple VPCs
^^^^^^^^^^^^^
Best suited for:
* Single team or single organizations, such as managed
  services providers.
* Limited teams, which makes it easier to maintain
  standards and manage access.

Exceptions:
* Governance and compliance standards might require
  greater workload isolation regardless of organizational complexity.

Multiple Accounts
^^^^^^^^^^^^^^^^^
Best suited for:
* Large organization or orgs with multiple IP teams.
* Medium-sized orgs that anticipate rapid growth.

Why?
* It can be mor difficult to manage access and
  standards in more complex orgs.


VPC Service Limits
------------------

VPC Service Limits
^^^^^^^^^^^^^^^^^^
Only 5 VPCs per region per account. (Can be increased
to 100.)

Up to 200 subnets per VPC.

IPv4 CIDR blocks per VPC 5. (Can be increased to 50.)

IPv6 CIDR blocks per VPC: 1. (Cannot be increased.)


VPC Design Best Practices
-------------------------

VPC Design Best Practices
^^^^^^^^^^^^^^^^^^^^^^^^^
* Use more AZs for HA and disaster recovery

* Use separate subnets for unique routing requirements.

* Use independent routing tables configured for every
  private subnet to control the flow of traffic within
  and outside the VPC.

* Size you VPC CIDR and subnets to support significant
  growth for the expected workloads.

* Do not allocate all network addresses at once.
  Instead, ensure that you reserve some address space
  for future use (overprovision).

* Use network ACLs sparingly, since the rules are harder to write.

* Use multiple layers of security.

  * It may make sense to have a host-based firewall in
    addition to AWS resources.
  * IDS, IPS

* Ensure that your VPC network range (CIDR block) does
  not overlap with your orgs other private network ranges.

* Use highly available NGWs where supported instead of NAT instances.


VPC Features
------------

VPC Peering
^^^^^^^^^^^
A VPC peering connection is a networking connection
between two VPCs that enables you to route traffic
between them privately.

A VPC peering connection is a networking connection between two VPCs that
enables you to route traffic between them privately. Instances in either
VPC can communicate with each other as if they are within the same network.

AWS uses the existing infrastructure of a VPC to create a VPC peering
connection; it is neither a gateway nor an AWS Site-to-Site VPN connection, and does not rely on a separate piece of physical hardware. There is no single point of failure for communication or a bandwidth bottleneck.

It's like merging the namespaces of two virtual networks.

You can connect VPCs:
* In your own AWS account,
* between your AWS accounts,
* or between AWS regions.

Limitations:
* IP spaces cannot overlap
* Transitive peering is not supported
* Only one peering resource between the same two VPCs is possible

See ``lab-2_vpc_peering`` for an example. It has steps to set it up
using the web interface and an automated version in terraform.

AWS Site-to-Site VPN Connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Site-to-site connections are VPNs between your VPCs.

In order to set it up you must...

* Have a gateway at another site
* Create a virtual gateway for your site
* Create a site-to-site vpn connection
* Associate the two gateways with the
  site-to-site vpn connection resource

I haven't found a lab for this yet. (The ones I've encountered
automate it in CloudFormation, or have unrelated setup.)

Direct Connect
^^^^^^^^^^^^^^
Direct Connect is also known as DX.
This is an 802.1q VLAN between two VPCs.
You get a dedicated line to a Point-Of-Presence for AWS,
and a circuit from there to the AWS network.

Direct connect is *expensive*.

Transit Gateway
^^^^^^^^^^^^^^^
Transit gateway is a service to manage connections
between multiple sites, accounts, and VPCs from A
central place.

Here is a decent overview of it: `Advanced VPC Connectivity
Patterns Video <https://www.youtube.com/watch?v=X_4ekgRc4C8>`_.

here is a lab scenario: `aws site-to-site vpn lab with
transit gateway <https://github.com/jamboubou/aws-site-to-site-vpn-lab>`_.

