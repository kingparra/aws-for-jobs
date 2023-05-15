***********
 Project 4
***********


Problem description
-------------------

Part 1
^^^^^^
Piotr our Database Base Administrator (DBA) has
requested that we deploy a Linux EC2 instance for a
development database. The team prefers to run this DB
on a instance that he can manage and provided the
following requirements

* Deploy an Instance using Amazon Linux AMI
* Install MariaDB (he provided the steps to configure
  it as he needs it)

  On Amazon Linux 2023::

    ## Install mariadb
    dnf install mariadb105-server

    ## Start mariadb
    systemctl start mariadb

    ## Test mariadb
    mysql_secure_installation

  For Amazon Linux 2::

    curl -LsS -O https://downloads.mariadb.com/MariaDB/mariadb_repo_setup
    bash mariadb_repo_setup --os-type=rhel --os-version=7 --mariadb-server-version=10.9
    amazon-linux-extras install epel -y
    yum install MariaDB-server MariaDB-client
    systemctl enable --now mariadb
    mariadb-secure-installation

* EBS Volume should be 20GB
* Only allow SSH from anywhere (for testing purpose)
  and MariaDB traffic from our corporate IP
  (96.241.172.40)Project 4

Part 2
^^^^^^
Later on, Piotr requested some changes to the instance:

* Resize the EBS volume to 30GB

  Steps to resize the EBS

  1. First modify EBS volume from the console.
  2. Check partition size: ``lsblk``
  3. Grow the partition: ``growpart /dev/xvda 1``
  4. Get filesystem information: ``file -s /dev/xvd*``
  5. Grow filesystem: ``xfs_growfs -d /``

* Take a snapshot of the volume after installing the DB (for safety)
* Resize the partition (at the OS level)
* Resize filesystem (at the OS level)


Solution
--------
For this lab, I've done everything manually
through the web console and recorded a screencast.
I don't plan to automate this.
