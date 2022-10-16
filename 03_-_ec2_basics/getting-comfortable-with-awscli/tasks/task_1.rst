Task 1
******
Using the CLI
deploy two EC2 instances on subnet ``us-east-1c``
with a security group
that allows SSH and HTTP traffic.

.. What is a subnet in AWS? The same thing as a regular subnet, dude.
   It belongs to your VPC.
.. What is a VPC? A virtual private cloud. Has it's own network.
.. What is a security group? Basically a firewall zone.
.. What is AWS Classic?

The instance should use the latest AMI.

Attach your key-pair.

Use ``./scripts/dev.bash``
to install an Apache webserver
using user-data.

You will need to alter the script
to get the ``public-hostname`` metadata
and assign it to ``PHOSTNAME``.

After you deploy the instances, add these tags::

  Name: DevServer
  Env: Dev
  Terminate: yes
