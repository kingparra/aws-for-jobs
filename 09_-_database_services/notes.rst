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


Relational Databses
-------------------
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


Relational Databse Service
--------------------------
What does using a managed service like RDS save you from?
Backups, replication, HA, OS patching, hardware concerns.


RDS in a VPC
------------
Usually DBs are in a private subnet, and only exposed to particular EC2 instances.


RDS Read Replicas
-----------------
Read replicas are read-only copies of your database that recieve updates from
your master db asynchronously.


Redis
-----



Aurora High Availability
------------------------
Backups are continuous and incremental. They have a rentention period.

There are four components involved in backups, SSM, a service role for SSM,
the RDS cluster, and a key used to encrypt everything.

1. SSM creates a snapshot.
2. SSM describes the snapshot.
3. SSM copies the snapshot to a cross-region snapshot.

Aurora stores multiple copies of your data in different AZs.
It creates copies of the DB in six AZs, two copies per AZ.
The DB cluster volume is backed by multiple copies.

After a DB crash, aurora does not need to rebuild.
