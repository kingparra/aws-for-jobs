Module 5: Storage
*****************


Overview
--------
* Storage
* Amazon simple storage services (Amazon S3)
* Amazon S3 storage classes
* Amazon S3 bucket URLs (two styles)
* Amazon S3 data redundancy
* Amazon S3 seamless scaling design
* Amazon S3 common use cases
* Amazon S3 common scenarios
* Amazon S3 pricing
* Amazon elastic file system (Amazon EFS)
* Amazon EFS features
* Amazon EFS architecture
* Amazon EFS implementation
* Amazon EFS resources
* Amazon S3 glacier
* Amazon S3 glacier: retrieval options
* Amazon S3 glacier: use cases
* Using Amazon S3 glacier
* Lifecycle policies
* Storage comparison
* Server-side encryption
* Amazon S3 glacier security


Storage
-------

Core AWS Services
^^^^^^^^^^^^^^^^^
Categories of core AWS services: VPC, EC2, storage, databases, IAM.

Storage
* S3 - each file becomes an object, and gets a URL
* EBS - block level
* EFS - filesystem level
* S3 Glacier - cold storage

Databases
* Amazon relational DB service
* Amazon dynamo DB

**Only one EC2 instance can mount an EBS volume at a time.***

AWS storage options: block storage vs object storage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
What if you want to change **one character** in a 1GB file?

Block storage: Change one block that contains the character.

Object storage: Entire file must be updated.

Amazon Elastic Block Storage (EBS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Amazon EBS enables you to create individual storage volumes and attach them to an amazon EC2
instance.

* Amazon EBS offers block-level storage.
* Volumes are automatically replicated within its AZ.
* Storage device that retains data after power to that device is shut off.
* Scale your storage devices up or down within minutes.
* It can be backed up automatically to Amazon S3 through snapshots.
* Users include:

  * Boot volumes and storage for EC2 instances
  * Data storage within a file system
  * Database hosts
  * Enterprise applications (???)

Amazon EBS volume types
^^^^^^^^^^^^^^^^^^^^^^^
SSD
* General purpose SSD

  * recommended for most workloads.
  * System boot volumes.
  * Virtual desktops.
  * Low-latency interactive applications.

* Provisioned IOPS

  * Critical business applications that require sustained IOPS performance,
    or more than 16000 IOPS or 250MiB/s of throughput per volume.
  * Large database workloads.

HDDs
* Throughput-optimized

  * Streaming workloads that require consistent, fast throughput at a low price.
  * Big data.
  * Data warehouses.
  * Log processing.
  * It cannot be a boot volume.

* Cold

  * Throughput-oriented storage for large volumes of data that is infrequently accessed.
  * Scenarios where the lowest storage cost is important.
  * It cannot be a boot volume.

Amazon EBS Features
^^^^^^^^^^^^^^^^^^^
* Snapshots

  * Point-in-time snapshots
  * Recreate a new volume at any time

* Encryption

  * Encrypted amazon EBS volumes
  * No additional cost

* Elasticity

  * Increase capacity
  * Change to different types (HDD/SSD)

Amazon EBS volumes, IOPS, and pricing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Volumes

  * EBS volumes persist independently from the instance.
  * All volume types are charged by the amount that is provisioned per month.

* Volume types:

  * General purpose SSD

    * Charged by the amount that you provision in GB per month until storage is released.

  * Magnetic

    * Charged by the number of requests to the volume

  * Provisioned IOPS SSD

    * Charged by the amount that you provision in IOPS (multiplied by the percantege of days that
      you provision for the month)

Amazon EBS snapshots and data transfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Snapshots

  * Added cost of EBS snapshots to S3 is per GB-month of data (what?).

* Data transfer

  * Inbound data transfer is free.
  * Outbound data transfer across regions incurs charges.



Amazon simple storage services (Amazon S3)
------------------------------------------

Amazon S3 overview
^^^^^^^^^^^^^^^^^^
* Data is stored as object in buckets
* Virtually unlimited storage

  * Single object is limited to 5TB

* Designed for 11 9's of durability.
* Granular access to bucket and objects.

Video only content (not in the slides)

  * Software as a service -- you don't manage any servers.
  * You can store database snapshots as objects.
  * Objects are assigned to URLs.
  * You can retrieve them with HTTP{,S}.


Amazon S3 storage classes
-------------------------

Amazon S3 storage classes
^^^^^^^^^^^^^^^^^^^^^^^^^
S3 offers a range of object-level storage classes that are designed for different use cases:

* S3 Standard
* S3 Intelligent-Tiering
* S3 Standard-Infrequent Access (S3 Standard-IA)
* S3 One Zone-Infrequent Access (S3 One Zone-IA)
* S3 Glacier
* S3 Glacier Deep Archive

Amazon S3 bucket URLs (two styles)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To upload your data:

1. Create a bucket in a region.
2. Upload almost any number of objects to the bucket.

Bucket path-style URL endpoint::

  https://s3.{region_code}.amazonaws.com/{bucket_name}

Bucket virtual hosted-style URL endpoint::

  https://{bucket_name}.s3-{region_code}.amazonaws.com

Amazon S3 data redundancy
^^^^^^^^^^^^^^^^^^^^^^^^^
* Buckets are associated with a region, and replicated across AZs.

Amazon S3 seamless scaling design
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* You can store as much data as you want, the back-end will scale seamlessly.



Amazon S3 pricing
-----------------

Amazon S3 pricing
^^^^^^^^^^^^^^^^^

Charged for:
* GB per month
* transfer out to other regions
* put, copy, post, list, and get requests

**As a general rule, you pay only for transfers that cross the boundary of your region.**

Not charged for:
* transfers into S3
* transfers out from S3 to CloudFront or EC2 in the same region


Amazon S3 storage pricing
-------------------------
A S3 object **storage class** is a billing policy based on
data access, resiliency, and cost requirements.

https://aws.amazon.com/s3/storage-classes/

Requests
* get requests have a different rate than other requests.


Server-side encryption
----------------------
Each object gets its own key.
A master key is used to encrypt each key that corresponds to an object.
You can manage the master key yourself, or let amazon do it.

SSE-S3 Server-side encryption


Amazon S3 Glacier
-----------------

Amazon S3 Glacier
^^^^^^^^^^^^^^^^^
S3 Glacier is a data archiving service.
It's intended to store data for long-term preservation.

Options for accessing archives:

* expedited
* standard
* bulk


Lifecycle policies
------------------
Policies enable you to delete or move objects based on age.


Storage comparison
------------------

+-------------------+-----------------------------+-----------------------+
| Characteristic    | S3                          | S3 Glacier            |
+===================+=============================+=======================+
| Volume data limit | No limit                    | No limit              |
+-------------------+-----------------------------+-----------------------+
| Average latency   | ms                          | minutes or hours      |
+-------------------+-----------------------------+-----------------------+
| Item size         | 5TB max                     | 40TB max              |
+-------------------+-----------------------------+-----------------------+
| Cost/GB per month | Higher cost                 | Lower cost            |
+-------------------+-----------------------------+-----------------------+
| Billed requests   | PUT, COPY, POST, LIST, GET  | Upload and retrieval  |
+-------------------+-----------------------------+-----------------------+
| Retrieval pricing | ¢                           | ¢¢                    |
+-------------------+-----------------------------+-----------------------+


EFS (Elastic File System)
-------------------------
* Can be thought of as a filesystem shared over NFS.
* Back-end scales automatically as files are added/removed.
* Petabyte-scale, low-latency
* Supports NFSv4.{0,1}
* Compatible with all Linux based AMIs
* Supports writes from multiple nodes at the same time, unlike block storage.


EFS Implementation
------------------
1. Create instances
2. Create EFS FS
3. Create mount targets in appropriate subnets
4. Connect your EC2 instances to the mount targets
5. Verify the resources and protection of your AWS account (what does this mean?)

EFS Resources
-------------
Mount target
* Subnet ID
* Security groups
* VPC
* Subnet
* AZ
