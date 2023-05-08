What are all of the ways I can possibly create an instance?  (Pulumi, Terraform, Ansible, SparkleFormation, CloudFormation, CDK, curl+API, Haskell's ``aws`` package, ...)

How do I build and upload my own AMI?

Can I convert an existing virtual machine into an EC2 instance?

Can VMs be live-migrated to AWS?

Are there any OS's that AWS doesn't allow you to run?

What CPU architectures are supported?

What (API) resources does EC2 provide?

What actions on those resources are supported?

How does ``cloud-init`` work?

How are encrypted block devices for ec2 instances unlocked
without user intervention on boot?
* Does it use KMS to do policy-based decryption using a TPM?
* Relevant article https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/security_hardening/configuring-automated-unlocking-of-encrypted-volumes-using-policy-based-decryption_security-hardening

What are you charged for when creating an instance?

* Purchasing options
* Instance type
* AMI (if commercial OS)
* Data transfer in and out of the instance.

How do I connect to the serial console of an instance?

* The instance type must be one compatible with nitro.
* The AMI must be configure to start a ``getty``
  service on a serial terminal device.
  ``systemctl start serial-getty@.service``
