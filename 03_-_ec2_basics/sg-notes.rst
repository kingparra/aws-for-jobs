Security Groups
***************
SGs are virtual firewalls.

They don't exist within the VM like a host-based fw,
or as a separate network device,
but as a software entity that is part of AWS's virtualization platform.

They are associated with the vNIC of an instance.

You can have up to five SGs per instance.

https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_SecurityGroup.html

Attributes:

* ``groupDescription``
* ``groupId``
* ``groupName``
* ``IpPermissions``
* ``IpPermissionsEgress``
* ``ownerid``
* ``tagSet``
* ``vpcid``
