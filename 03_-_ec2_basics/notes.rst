Elastic compute cloud basics
****************************

EC2
---

Regions and AZs
^^^^^^^^^^^^^^^
* Each region is a separate geographic area.
* Each region has multiple isolated locations known as availability zones.

Key concepts
^^^^^^^^^^^^
* Instance, AMI, instance types, key pair, VPC
* VPC Virtual Private Cloud. Virtual networks you can create that are logically isolated from the
  rest of the AWS cloud, and that you can optionally connect to your own network. (Think two LANs
  connected by a VPN, but one of the LANs is hosted in the cloud.)

EC2 pricing
-----------

Purchasing options
^^^^^^^^^^^^^^^^^^
* On demand instances
* Reserved instances

  * Commit to running for 1-3 years
  * Price discount
  * Can pay all up front, partial up front, or no up front.
  * You are responsible for paying for this regardless of if you use it or not.

* Spot instances

  * Bid for unused compute capacity
  * Instance is available to you while the spot price is equal or below your bid price
  * Price fluctuates based on supply and demand.
  * Instances can be interrupted.

What are you charged for?
^^^^^^^^^^^^^^^^^^^^^^^^^
* Purchasing options

  * spot
  * on-demand
  * reserved

* Instance type

  * general purpose
  * compute optimized
  * accelerated computing
  * memory optimized
  * storage optimized

* EBS optimized : A premium that allows more IOPS performance.
* AMI Type (linux/windows)
* Data transfer in or out of instance
* Region

https://aws.amazon.com/ec2/instance-types/


EC2 instance types
------------------

EC2 instance types and families
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
An instance type essentially determines the hardware of the host computer used for your instance.
Each instance type offers different compute and memory capabilities.

Select and instance type based on the amount of memory and computing power that you need for the
application or software that you plan to run on the instance.


EC2 instance types (diagram)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* general purpose
* compute optimized
* storage and I/O optimized
* memory optimized
* GPU or FPGA enabled


EC2 storage
-----------

Block storage
^^^^^^^^^^^^^
* Think iSCSI, SAN, local disks. Blocks, not filesystems.
* Most commonly used storage type for most applications.
* **Can be locally attached or network attached.**

Instance store volumes
^^^^^^^^^^^^^^^^^^^^^^
* Storage volumes for temporary/ephemeral data that's deleted when you stop or terminate your
  instance.
* If the instance fails, stop, or get terminated the data on these volumes is lost.
* Best used for temporary data.
* Local to instance.
* Data not replicated.
* No snapshot support.

Elastic block storage volumes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Persistent storage volumes for your data using EBS.
* 99.999% availability.
* Consistent and low-latency block storage.
* Volume is **automatically replicated within its AZ.**
* Point in time snapshot support.
* Modify volume types and size as needed.

EBS volume types
^^^^^^^^^^^^^^^^
* SSD backed storage

  * highest performance
  * ideal for transactional workloads, such as databases and boot volumes

    * gp2 - general purpose - balances price and performance for a wide variety of transactional data.
    * io1 - Provisioned IOPS - Provides high performance for mission-critical, low-latency, or
      high-throughput workloads.

* HDD-backed storage

  * Ideal for throughput intensive workloads, such as MapReduce and log processing. **Wait, why is
    this true?**
  * st1 - Throughput optimized - frequently accessed, throughput intensive workloads
  * sc1 - Cold HDD - for less frequently accessed data.


EBS snapshots
-------------

What are EBS snapshots?
^^^^^^^^^^^^^^^^^^^^^^^
* Point-in-time backup of an EBS volume
* Can be used as a baseline for new volumes or for just data backup
* Snapshot is stored in s3 **what is data durability**
* First snapshot is clone of the volume
* Subsequent snapshots are incremental
* Can take a snapshot of an attached volume that is in use

Use cases
^^^^^^^^^
* Backup
* Disaster recovery
* Dev/test clones


EC2 stopping vs terminating
---------------------------

Stopping vs terminating an instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

stopping an instance
~~~~~~~~~~~~~~~~~~~~
* **Almost the same as a power-off, with a few differences.**
* All EBS volumes remain attached, and you can start the instance again at a later time.
* You are not charged for additional instance usage while the instance is in a stopped state.
* All of the associated amazon EBS usage of your instance, including root device usage, is billed using typical amazon ebs prices.
* When an instance is in a stopped state, you can attach or detach amazon ebs volumes.
* You can also create an ami from the instance, and you can change the kernel, ram disk and instance
  type.

terminating an instance
~~~~~~~~~~~~~~~~~~~~~~~
* When an instance is terminated, the instance performs a normal shutdown.
* The root device volume is deleted by default, but any attached EBS volumes are preserved by default.
* The **instance itself is also deleted**, and you can't start the instance again at a later time.


EC2 AMI
-------

What's included in an AMI?
~~~~~~~~~~~~~~~~~~~~~~~~~~
* Template for the root volume of the instance

  * OS
  * Applications
  * Configs
  * Data

* Launch permissions (which AWS accounts can use the AMI)
* Block device mapping (specified the volumes to attach to the instance when it is launched.)

Types of AMIs
~~~~~~~~~~~~~
* Community AMIs
* AWS MarketPlace

  * Pay to use
  * Usually bring additional licensed software

* Custom AMI

  * created and managed by your organization


Security groups
---------------

Firewall
^^^^^^^^
* A security group acts as a virtual firewall on the instance

Security groups
^^^^^^^^^^^^^^^
* Control access to specific ports
* Controls inbound/outbound traffic
* Source/dest ips to instances
* Acts at the instance level, not the subnet level
* Each instance in a subnet in your VPC can be assigned to a different set of security groups

Security groups are stateful
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Security groups do connection tracking and allow incoming traffic belonging to a connection
  initiated from the instance.
* This means that responses to allowed inbound traffic are allowed to flow out, regardless of
  outbound rules.

Security groups assignment
^^^^^^^^^^^^^^^^^^^^^^^^^^
* One SG can be assigned to multiple instances
* One instance can have up to five security groups
* The SG is at a layer outside the instance

  * If traffic is blocked, you instance won't be aware of it.

* SGs are VPC/region specific.
* By default all inbound traffic is blocked.
* By default all outbound traffic is allowed.


Tags
----

Tags
^^^^
* Key:value pairs you can define and attach to resources.
* Can be used to categorize resources in different ways, for example, by purpose, owner, or
  environment.
* Tags have many use cases and tend to be critical for organizations adopting cloud services.

  * Cost allocation
  * Automation (filtering, identification)
  * Access control: Used to set conditions on IAM access policies
  * Security: Identify resources that require higher security.


Instance Metadata
-----------------

Instance Metadata
*****************
* Every EC2 instance has access to a URL to view local instance metadata and userdata.

  http://196.245.169.254/

* Instance metadata is data about your instance that you can use to configure or manage the running
  instance.
* This includes information like the instance id, public and private ip addresses, current IAM role,
  security groups, account ID, region, and more!
* This metadata is used to configure the instance and to query by configuring management tools and
  scripts.

Examples
^^^^^^^^

::

  curl http//196.254.169.254/latest/meta-data/instance-id

  curl http//196.254.169.254/latest/meta-data/network/interfaces/macs
  curl http//196.254.169.254/latest/meta-data/network/interfaces/macs/$MAC/vpc-id

  ip=$(curl http//196.254.169.254/latest/meta-data/local-ipv4)

  region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)


Userdata
--------

Bootstrapping
^^^^^^^^^^^^^
* Boostrapping = launch commands when an instance starts
* Common forms of bootstrapping

  * Apply latest patches
  * Install applications
  * Copy code from S3 buckets or a repo
  * Install or configure CM agent.

Userdata
^^^^^^^^
* Userdata can be used to bootstrap instances in AWS at launch time
* It is a scrip that is executed at the first boot


EC2 Security
------------

Do your part
^^^^^^^^^^^^
* Do the bare minimum and change the default password, use polp, etc.


Isolation and traffic control
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* VPC provides network isolation since it's a virtual network that is logically isolated.
* You can isolate it even more by segregating your workloads into subnets (DB, web, application).
* Use private subnets if the instances should not be accessed directly from the internet.
* Use ACLs at the subnet layer to control traffic in and out.
* Use SGs at the instance layer to control traffic before it arrives at the Instance (mandatory).
* Use OS firewalls if you want to control traffic at the instance (more logging).
* Take advantage of PrivateLink Endpoints to prevent your traffic from going through the internet to
  reach AWS services.
* Third party IPS/IDS.


OS level security
^^^^^^^^^^^^^^^^^
* Everything at the OS level is controlled by the customer.
* Setting up an OpenSSH CA and bastion host is probably a good idea.


Encryption
^^^^^^^^^^
* Encrypt your data in transit.
* Encrypt your data at rest.


Monitor
^^^^^^^
* Monitor your shit, yo!
* Cloudwatch: metrics about your instances (cpu utilization, network traffic, etc.)
* Cloudtrail/Config: changes mad to your instances (non OS level changes).
* Can use cloudwatch or 3rd party tools to collect OS level logs that have security monitoring
  value.
