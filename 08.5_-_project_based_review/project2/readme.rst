***********
 Project 2
***********


Problem description
-------------------
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

Solution
--------
Here is a diagram of the resources involved in creating
this VPC configuration:

.. raw:: html
   :file: diagram-resources.drawio.html

Here is what the traffic ingress looks like:

.. raw:: html
   :file: diagram-traffic-ingress.drawio.html

And here is what the data egress looks like:

.. raw:: html
   :file: diagram-traffic-egress.drawio.html

Creating VPCs is a common task on AWS, so there
are many ways to create this configuration.
I'll list the ones that I've personally tried
from hardest to easiest.

* Create all of the resources by hand in the 
  web console and connect them together.
  This is what I've done in the screencast
  for mod 4.
  
* Through the web console, use the "VPC and
  more" wizard when creating the VPC.
  It will create every resource here, and 
  allow you to set a name prefix. I have done
  this but not recorded it.
  
* Using Terraform, create each resource 
  individually and connect them together.
  This is the approach I take in the module
  4 labs.
  
* Use the VPC module from the Terraform 
  registry to create all the resources 
  in one go. This is the approach I take
  in my Terraform solution for this lab.
