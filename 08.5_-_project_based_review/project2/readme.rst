***********
 Project 2
***********
We are required to build a VPC that leverages
Availability Zones ``us-east-1a`` and ``us-east-1b``.

* VPC should use 10.0.0.0/16

* Naming convention should use the following prefix for
  all resources: ``aurora-prod-*``

* Create 2 public subnets that can fit at least 50 hosts

* Create 2 private subnets that can fit at least 120 hosts

* Create Routing tables for every type of subnet and
  associate the route tables with the corresponding
  subnets

* Make sure the main route table is not in use

* Validate that you can deploy instances on all
  subnets and that these instances have the ability
  to reach the internet for updates.

