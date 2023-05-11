***********
 Project 4
***********

Part 1
------
Piotr our Database Base Administrator (DBA) has
requested that we deploy a Linux EC2 instance for a
development database. The team prefers to run this DB
on a instance that he can manage and provided the
following requirements

* Deploy an Instance using Amazon Linux AMI
* Install MariaDB (he provided the steps to configure
  it as he needs it)
* EBS Volume should be 20GB
* Only allow SSH from anywhere (for testing purpose)
  and MariaDB traffic from our corporate IP
  (96.241.172.40)Project 4

Part 2
------
Later on, Piotr requested some changes to the instance:

* Resize the EBS volume to 30GB
* Take a snapshot of the volume after installing the DB (for safety)
* Resize the partition (at the OS level)
* Resize filesystem (at the OS level)
