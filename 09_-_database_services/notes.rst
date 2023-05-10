*****************************
 Module 9: Database Services
*****************************


Questions
---------


Database Consideration
----------------------
Which db or db service should you use? Here are some things to consider.

Scalability
^^^^^^^^^^^
* How much throughput is needed?
* Will the chosen solution be able to scale up later, if needed?

Total storage requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^
* How large does the database need to be?
* Will it need to store GBs or TBs or PBs or data?

Object size and type
^^^^^^^^^^^^^^^^^^^^
* Do you need to store simple data structures, or large data objects, or both?

Durability
^^^^^^^^^^
* What level of data durablity, data availability, and recoverability is required?
* Do regulatory obligations apply?

Database Schema
---------------
A schema is an outline of the architecture of a DB. It will help ensure the following:

* Consistent formatting of data entries
* All record entries have a unique primary key
* No important data is ommitted

What is in the schema:

* Tables
* Rows
* Types of each row
* Relationships between tables (forign keys, constraints)


Database types
--------------
* Relational: MS SQL Server, Oracale DB, MySQL, PostgreSQL
* Non-relational: MongoDB, Cassandra, Redis


Relational Databases
--------------------
The relational model is probably the most widely used.

Relational DBs are ideal when you:

* Need strict schema rules, ACID compliance, and data quality enforcement.
* Do not need extreme read/write capacity.
* Do not need extreme performance.


Non-Relational DBs
------------------
Examples of non-relational models includ key-value, graph, and document.

Non-relational is ideal when you:

* Must scale horizontally to handle massive data volume
* The data may have inconsistent structure, or does lend itself well to traditional schemas
* Read/write rates exceed what can be economically supported through traditionsl RDBMS.


Relational Database Service
---------------------------
What does using a managed service like RDS save you from?
Backups, replication, HA, OS patching, hardware concerns.


RDS in a VPC
------------
Usually DBs are in a private subnet, and only exposed to particular EC2 instances.


RDS Read Replicas
-----------------
Read replicas are read-only copies of your database that recieve updates from
your master db asynchronously.


Aurora High Availability
------------------------
Backups are continuous and incremental. They have a retention period.

There are four components involved in backups, SSM, a service role for SSM,
the RDS cluster, and a key used to encrypt everything.

1. SSM creates a snapshot.
2. SSM describes the snapshot.
3. SSM copies the snapshot to a cross-region snapshot.

Aurora stores multiple copies of your data in different AZs.
It creates copies of the DB in six AZs, two copies per AZ.
The DB cluster volume is backed by multiple copies.

After a DB crash, aurora does not need to rebuild.


DynamoDB
--------
Amazon DynamoDB is a fully managed, serverless,
key-value NoSQL database designed to run
high-performance applications at any scale.

DynamoDB offers built-in security, continuous backups,
automated multi-Region replication, in-memory caching,
and data import and export tools.

Scalability
^^^^^^^^^^^
Dynamo has insane horizontal scalability. Uptime is
99.999% according to the SLA page. That's less than 5
minutes of yearly downtime.

SaaS
^^^^
DynamoDB is a SaaS offering, so you don't have access
to the instances, and can't control it's networking
like you can with RDS on VPC. The way permissions are
handled is different, too. There isn't an internal
permissions system, instead you manage it with IAM.
DynamoDB integrates with with a other AWS services,
too.

Data modelling
^^^^^^^^^^^^^^
DynamoDB is best suited for data with known access
patterns. Unknown access patterns may be suboptimal.

The vocabulary for DynamoDB is different than
relational databases.

(Table ~= Table).
(Item ~= Record).
(Attribute ~= Column).

In DynamoDB an attribute is a Key-Value pair.

In DynamoDB the primary key is composed of a *partition
key* and an optional *sort key*. **You can't add a sort
key after your primary key has been created.**

Dynamo also has the option of creating a *global
secondary index* or GSI to speed up lookups of other
attributes.

One thing to know about tables is that they are
region-specific.

Working with data
^^^^^^^^^^^^^^^^^
Databases in DynamoDB are not manipulated with SQL, but
with APIs or ORMs, instead. You can also interact with
it using the PartiQL editor in the web console. The
datatypes in DynamoDB can potentially be much more
complex than what is typically used in a relational
database -- things like strings, bools, sorted sets,
and complex objects in json form.


Import / Export / Backups
^^^^^^^^^^^^^^^^^^^^^^^^^
You can import and export from S3. Read about backups
yourself. **You can also stream data to Kinesis.**

Pricing
^^^^^^^
DynamoDB charges for reading, writing, and storing data
in your DynamoDB tables, along with any optional
features you choose to turn on. DynamoDB has on-demand
capacity mode and provisioned capacity mode, and these
modes have pricing for processing reads and writes on
your tables.

Provisioned capacity can be significantly less
expensive than on-demand.

