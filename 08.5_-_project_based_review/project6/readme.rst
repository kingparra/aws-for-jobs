***********
 Project 6
***********


Problem description
-------------------
We have been tasked with creating a management VPC
where we will host an Ansible Server to manage all the
configurations of our instances.

The team that handles the Ansible server wants to
remain in a completely isolated VPC that they control.

They have provided a CloudFormation template to deploy
their VPC as well as their Ansible Server.

However, we need to configure allow communications
between the aurora-prod-VPC and the management VPC.

We also have to do the pre-work to allow ansible to
interact with our instances.

VPC Peering Stage

* Deploy central VPC and ansible server using
  CloudFormation template

* Create peering connection from central VPC to aurora
  VPC

* Deploy an Instance on the public subnet of the
  aurora-prod-VPC (Allow SHH, ICMP, HTTP)

* Test connectivity by pinging from an instance in one
  VPC to an instance in the other VPC (using private
  IPs) Ansible Setup Stage

* Create ansible user on both instances

* Make the ansible user a privileged user on both
  instances

* Create an ssh key on the ansible server. This is how
  ansible will be able to ssh without a password into
  aurora-prod-VPC EC2 instance

* copy the ssh key to your aurora-prod-VPC EC2 instance

* Using the ansible server install httpd and create the
  ``index.html`` file (ansible playbook)


Solution
--------
I already have a solution to this lab in the Module 4
directory. Check it out.
