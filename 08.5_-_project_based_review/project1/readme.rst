Review Mega Project
*******************


Problem Description
-------------------
You have been entrusted with the task of setting up a highly available web
server on AWS for a prominent fitness compnay called Energym. The website
should be configured to exclusively accept HTTP.

Upon successful deployment, take a snapshot of the EBS volume, and create a
golden AMI, laying the foundation for seamless future deployments. To ensure
proper cost allocation, tag the server with the clients name.

The website's code resides in a S3 bucket, ``s3://yt-websites-2023/energym-html``.
It is highly reccomended that you throughly teset the AMI to ensure it meets
the expected functionality.


Phase 1 - Work on your test server
----------------------------------
* Create an instance profile (we need an IAM role so the EC2
  instance can copy the website files from an S3 bucket).
* Create an instance, with type t2.micro, and attach the role.
* Add 1 storage drive (root 16 GiB).
* Make sure the server OS gets updated at deployment and install httpd.
* Copy website code from s3 using userdata. ``s3://yt-websites-2023/energym-html/``
* Take the instance with ``Client=Energym``.
* Test your ability to access the website.

::

     AZ
     +-----------------------------+
  Region                           |
  +--------------------------------------------------------------+
  |  |VPC                          |                 +========+  |
  |  |+----------------------------------------+    /|  role  |  |
  |  ||  Public subnet             |           |   / +========+  |
  |  ||  +-----------------------+ |           |  /              |
  |  ||  |                       | |           | /   +========+  |
  |  ||  |                       | |           |/    |   S3   |  |
  |  ||  |  +===+    +------------------+      /     | bucket |  |
  |  ||  |  |EC2|<---| instance profile |<----+|     +========+  |
  |  ||  |  +===+    +------------------+      |          ^      |
  |  ||  |    ^                  | |           |          |      |
  |  ||  |    |                  | |           |          |      |
  |  ||  |    +---------------aws s3 cp ...---------------+      |
  |  ||  |                       | |           |                 |
  |  ||  +-----------------------+ |           |                 |
  |  |+----------------------------------------+                 |
  +--------------------------------------------------------------+
     |                             |
     +-----------------------------+


Phase 2 - Build your production AMI
-----------------------------------
* Create a snapshot from the EBS volume.
* Create an AMI from the snapshot.
* Test the AMI by deploying it to a new EC2 instance, make sure the website is
  available for the new instances.

::

    +=========+       +===========+       +=========+
    | Energym |       | S3 Bucket |       | Energym |
    | EBS Vol |------>| Energym   |------>|   AMI   |
    |         |       | Snapshot  |       |         |
    +=========+       +===========+       +=========+


Phase 3 - Deploy the production AMI with an ASG
-----------------------------------------------
* Create a launch template that uses your AMI
* Create an ASG for the production site (Des 2, Min 1, Max 3) with the new
  launch template (Select 2 public subnets from the default VPC)
* Attach an application load balancer to distribute the traffic to the instance behind the ASG.
* Create an alarm to trigger our ASG if CPU goes over 70% usage (using a target tracking policy)
* Test the behaviour of the ASG, using ``sudo yum install -y stress; sudo stress --cpu 8 &``
