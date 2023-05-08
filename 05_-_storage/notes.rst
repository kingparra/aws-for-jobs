Module 5: Storage
*****************


Module objectives
-----------------
* Core AWS services
* Block storage vs object storage
* EBS

  * Volume types
  * Volume types use cases
  * Features
  * Volumes, IOPS, and pricing

* S3

  * Storage classes
  * Data redundancy
  * Seamless scaling design
  * Data access
  * Common use cases
  * Pricing

* EFS

  * Features
  * Architecture


Storage services and levels of abstraction
------------------------------------------
S3 - object storage. Think of it as a content-addressable
filesystems like the git object store.

EBS - block storage. Like a virtual disk drive.

EFS - filesystem-level storage over a network. A NFS
share with a scalable back-end.

Block-level: A file is represented as blocks which are
stored on a disk (volume). A file can be altered in
place by writing to blocks withing it. The interface is
the OS disk driver.

Object storage: The unit of storage is an object. You
cannot modify an object (file) in-place, you must
replace it with a new object, instead. The interface is
a *transaction* (upload/download), which is delivered
over https.

Filesystem-level storage: The unit of storage is a file
(inode/dentry). The interface is at the syscall level,
which is sent over the network with a scheme known as RPC.


Amazon EBS
----------
EBS Allows you to create storage volumes and attach them to an instance. EBS
provides persistent block-level storage. It's like working with virtual disk
drives.

Volumes are automatically replicated *within* an AZs. EBS is a zonal service.

EBS volumes that are attached to an instance are exposed as storage volumes
that persist independently from the life of the instance.

The max volume size 16TiB across all storage device types.

Volume types
^^^^^^^^^^^^
* SSD

  * general purpose:

    * Max resource specs: 16TiB, IOPS 16000, 250 MiB/s
    * reccomended for most workloads
    * system boot volumes
    * virtual desktops
    * low-latency interactive applications
    * development and test environments

  * provisioned IOPS:

    * max resource specs: 16TiB, IOPS 64000, 1000 MiB/s
    * Apps that require sustained IOPS performance.
    * Large database workloads.

* HDD

  * throughput-optimized: 16TiB, IOPS 500, 500MiB/s

    * Streaming workloads that require consistend fast throughput at a low price.
    * Big data
    * Data warehouses
    * Log processing
    * It cannot be a boot volume

  * cold: 16TiB, IOPS 250, 250MiB/s

    * For cold storage, where access is infrequent, and low storage cost is important.
    * Cannot be a boot volume.

EBS Features
^^^^^^^^^^^^
* Snapshots. Snapshots are point-in-time copies of a volume.
* Encryption. Think LUKS.
* Elasticity. You can increase the capacity of an existing volume, without
  needing to stop an instance that is using it.

EBS Snapshots and data transfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* The cost of EBS snapshots (which are automaticaly moved to S3) is billed by GB per month.
* Inbound data transfer is free.


S3
--
S3 has unlimited storage!
Designed for 11 9's of durability. Holy. Shit.
A single object has a max size of 5TiB.
Redundant, objects are replicated in 3 or more AZs.

Objects live in a *bucket*.
A bucket must have a dns-resolvable name.

A bucket name is global to all of AWS, because it can be resolved to a url.

You can use S3 to host a static website.

Overall, S3 is a good service for files that don't change often,
especially assets for websites.


Amazon S3 Pricing
-----------------
There are six Amazon S3 cost components to consider when storing and managing your data:

* storage pricing,
* request and data retrieval pricing,
* data transfer and transfer acceleration pricing,
* data management and analytics pricing,
* replication pricing,
* and the price to process your data with S3 Object Lambda.

Don't actually try to figure out the price yourself, use https://calculator.aws

S3 URLS
-------

::

  https://s3.ap-northeast-1.amazonaws.com/$bucketName

  https://$bucketName.s3-ap-northeast-1.amazonaws.com



S3 Glacier retrieval options
----------------------------
* Standard: 3-5 hours
* Bulk: 5-12 hours
* Expedited 1-5 minutes


S3 Glacier use cases
--------------------
* Media assest archiving
* Healthcare information archiving
* Regulatory and compliance archiving
* Scientific data archiving
* Digital preservation
* Magenetic tape replacement


S3 Lifecycle Policies
---------------------
Lifecycle policies allow you to delete or move objects based on age.

``standard -(30 days)-> S-IA -(60 days)-> glacier -(1 year)-> delete``

S3 Stogage Comparison
---------------------
S3 max item size: 5TB. S3 Glacier max item size: 40TB.

Glacier is for cold storage, so you get changed more for access, and it takes a lot longer.

EFS
---
EFS is like a managed NFS share with an automatically scaled back-end.

Terraform resources:

* aws_efs_access_point
* aws_efs_backup_policy
* aws_efs_file_system
* aws_efs_file_system_policy
* aws_efs_mount_target
* aws_efs_replication_configuration

In traditional NFS setups, you have to set up a source of authentication
information for file ownership metadata / access control, and an encrypted
transport. There are many ways for security to go wrong with NFS.

For the encrypted transport, AWS uses stunnel.

EFS provides a mount helper (amazon-efs-utils) which tunnels NFS over TLS using
stunnel. Stunnel listens on port 2049 and sends traffic out on ports within
the range 20049..21049.

To temporarily mount an EFS share::

  sudo yum install -y amazon-efs-utils

  # fs-12345678 is the fsid of the efs fs, the mount helper turns it into a dns
  # name that resolves to the mount target attached to a subnet in the vpc.

  sudo mount -t efs -o tls fs-12345678:/ /mnt/efs

To make the mountpoint permanent::

  
EFS storage classes
^^^^^^^^^^^^^^^^^^^
* Standard
* Standard-Infrequent Access
* One zone
* One zone-Infrequent Access
