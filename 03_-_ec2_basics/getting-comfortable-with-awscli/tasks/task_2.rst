Task 2
******
Using the CLI
deploy an EC2 instance
on subnet ``us-east-1b``
with a security group
that allows ssh and http traffic.

The instance should use the latest AMI.

Attach your key-pair.

Use ``./scripts/prod.bash``
to install an Apache webserver
using user-data.

You will need to alter the script
to get the ``public-hostname`` metadata
and assign it to ``PHOSTNAME``.

Add these tags to the instance after you deploy it::

  Name: Prod-Server
  Env: Prod
  Terminate: yes
