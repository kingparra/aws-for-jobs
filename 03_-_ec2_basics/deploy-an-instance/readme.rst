Deploy an instance
******************
In this project I experiment with creating an EC2
instance using different tools.

Requirements for the instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Use the latest Amazon Linux 2 AMI
* Enable public IP using ``associate_public_ip_address``
* Instance must run in a public subnet
* Allow http traffic on the instance
* Run the ``user-data.bash`` script in the VPS
