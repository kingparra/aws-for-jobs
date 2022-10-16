Module 4: AWS Networking
************************

* Basics of networking
* OSI model
* Amazon VPC
* VPC subnetting
* Subnet demo
* Route tables and routes
* Public IP address types
* Network security
* Network access control lists (NACLs)
* NACLs demo
* Types of VPC
* VPC deployment options
* VPC service limits
* VPC design best practices
* VPC features

Amazon VPC
----------
Your very own LAN in the cloud.

Gives you control over:

* Selection of IP address ranges
* Creation of subnets
* Configuration of routes and network gateways

Like LANs, VPCs can be connected in different ways,
allowing for the design of different network topologies.

VPCs can be internal, or accessible from the internet.

VPCs provide the building blocks needed to build networks with multiple layers of security.

Unlike EC2-Classic, VPCs are dedicated to your own account.

The EC2-classic scheme is where your instances run in a single, flat network
that you share with other customers. This configuration is being retired.
Soon you will have to use a VPC.

* https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-classic-platform.html
* https://aws.amazon.com/blogs/aws/ec2-classic-is-retiring-heres-how-to-prepare/

VPCs belong to a single region, and can span multiple AZs.


IP Addressing
^^^^^^^^^^^^^
* When you create a VPC, you assign it to an IPv4 CIDR block.
* The address range cannot be changed after you create the VPC.

=======   ==========
CIDR       Addresses
=======   ==========
``/16``    65,536
``/28``    16
=======   ==========

Reserved IP addresses
^^^^^^^^^^^^^^^^^^^^^
Five IP addresses are reserved for any subnet you create:

==========  =================================
Address     Purpose
==========  =================================
``*.0``     Network address
``*.1``     router
``*.2``     DNS
``*.3``     Reserved for future use by AWS.
``*.255``   Broadcast address.
==========  =================================

Note that network broadcasts are not supported in VPCs!
This is an exam question, so be sure to memorize it.

VPC use cases
^^^^^^^^^^^^^
* Simple website.
* Multi-tier webapp.
* Disaster recovery.
* Extension of on-premises (internal) network to the cloud.
* Connect cloud applications to data centers in a secure way.
* Inspection of out-of-band and inline traffic.


VPC Subnetting
--------------

Subnets: diving your VPC
^^^^^^^^^^^^^^^^^^^^^^^^
Everything that you already know about subnets holds true for AWS, with a few additions.
Subnets are classified as public or private.
As mentioned above, AWS reserves five addresses in each subnet.

Subnet use cases
^^^^^^^^^^^^^^^^

=================  ==================
Instance use case  Subnet type
=================  ==================
Store data         Private
Batch processing   Private
Backend services   Private
Host webapp        Public or private
=================  ==================


Subnet demo
-----------

Route tables and routes
^^^^^^^^^^^^^^^^^^^^^^^
* A route table contains a set of rules (or routes) that you can configure to redirect network
  traffic from the subnet.
* Each route specifies a destination and a target.
* By default, every route table contains a local route for communication within the VPC.
* Each subnet must be associated with a route table (at most one).
* You can associate multiple subnets with the same route table.

Public IP address types
^^^^^^^^^^^^^^^^^^^^^^^
Public IPv4 Address
* Automatically assigned through the auto-assign public IP address setting at the subnet lvel or
  enabled at launch.

Elastic IP address
* An IP address that can be attached, detached, and reassigned to any instances NIC.
* Belongs to an AWS account.
* Additional costs may apply.

Elastic network interface
^^^^^^^^^^^^^^^^^^^^^^^^^
A virtual network interface that you can attach to any EC2 instance, and detach from the instance.
This can be used to redirect network traffic. It's attributes follow when it is reattached to a new
EC2 instance.

Each instance in your VPC has a default network interface that is assigned a private IPv4 address
from the address range of your VPC.


Network security
----------------

Network security
^^^^^^^^^^^^^^^^
* Security groups
* NACLs
* Flow logs
* Route tables and subnets

Network access control lists (NACLs)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* NACLs act at the subnet level.
* It acts as a firewall for one or more subnets.

Default NACLs
^^^^^^^^^^^^^
* A NACL has separate inbound and outbound rules that can either allow or deny traffic.
* The default NACL allows all inbound and outbound IPv4 traffic.

Custom NACLs
^^^^^^^^^^^^
* Custom NACLs have a rule, numbered at index 0, to deny all by default.
* Both allow and deny rules can be specified by you.
* Rules are evaluated from lowest index to highetst.
* You will need to allow outbound response traffic on ephemeral ports.

+========================+
|    Ephemeral ports     |
+===========+============+
| OS        | Port range |
+===========+============+
| Windows   | 1025-65535 |
+-----------+------------+
| Linux     | 1024-65535 |
+-----------+------------+


Types of VPC
------------

VPC types
^^^^^^^^^
* Default

  * Automatically created in every region when your AWS account is created.
  * Comes with a default subnet in each AZ.
  * Includes an internet gateway.
  * Each instance has a private IPv4 address and a public IPv4 address.
  * Allows users to:

    * Add non-default subnets
    * Modify the main route table
    * Add route tables
    * Associate additional route tables
    * Update the rules of the default security group
    * Add site-to-site VPN connections
    * Add more IPv4 CIDR blocks
    * Access VPCs in a remote region by using a DirectConnet gateway.

* Custom

  * Created by the user.

Single VPC deployment
^^^^^^^^^^^^^^^^^^^^^
Here are some limited cases where deploying one VPC may be appropriate.

* Small, single applications managed by a small team.
* HPC.
* Identity management.

For most use cases, there are two primary patterns for organizing your infrastructure:

* Multi-VPC; and
* multi-account.

Multiple VPCs
^^^^^^^^^^^^^
Best suited for:

* Single team or single org, such as MSPs.
* Limited teams, which makes it easier to maintain standards and manage access. (Tight coordination
  is required.)

Exceptions:

* Governance and compliance standards may require greater workload isolation regardless of
  organizational complexity.

Multiple accounts
^^^^^^^^^^^^^^^^^
Best suited for:

* Large organizations or orgs with multiple teams.
* Medium sized orgs that anticipate rapid growth.

Why?

* It can be more difficult to manage access and standards in more complex organizations.


VPC service limits
------------------

Amazon VPC service limits
^^^^^^^^^^^^^^^^^^^^^^^^^
* Only 5 VPCs per region per account (can be increased to 100).
* Subnets per VPC: 200.
* IPv4 CIDR blocks per VPC: 5 (can be increased to 50).
* IPv6 CIDR blocks per VPC: 1 (cannot be increased).


VPC design best practices
^^^^^^^^^^^^^^^^^^^^^^^^^
* Up to four AZ for HA and disaster recovery.
* Separate subnets for unique routing requirements.
* Do not allocate all network addresses at once. Instead, ensure that you reserve some address space
  for future use.
* Use additional ACLs when needed as an additional layer of security.
* Size your VPC CIDR and subnets to support significant growth for expected workloads.
* Use independent routing tables configured for every private subnet to control the flow of traffic
  within and outside the amazon VPC.
* Ensure that your VPC network range (CIDR block) does not overlap with your orgs other private
  network ranges.
* Use HA NAT gateways where supported instead of NAT instances.


VPC features
------------

VPC peering
^^^^^^^^^^^
A networking connection between two VPCs that enables you to route traffic between them privately.

You can connect VPCs:

* In your own AWS account
* Between your AWS accounts
* Or between AWS regions

Limitations:
* IP spaces cannot overlap.
* Transitive peering is not supported. (In other words, only direct connections are allowed.)
* Only one peering resource between the same two VPCs is possible.

AWS site-to-site VPN connection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AWS DirectConnect
^^^^^^^^^^^^^^^^^
