Readme
******
This is a lab to set up a site-to-site VPN between two
VPCs which are each hosted in different accounts.


STEP 1 - Launch EC2 in ON-PREMISES VPC (Production Account)
-----------------------------------------------------------
Launch EC2 instance:

* Disable source/destination checks
* Public subnet
* Security group: 22, ICMP=ALL
* Make a note of the public IP

STEP 2 - AWS VPC Configuration (Management Account)
---------------------------------------------------
Launch EC2 instance:

* Public or private subnet
* 22, ICMP=ALL

Create a customer gateway:

* Name: AWS-VPC-CGW
* Routing: static
* IP: public IP of on-premises EC2

Create VGW
* Name: AWS-VPC-VGW
* Attach to VPC

Create a VPN connection:

* Name: ON-PREM-AWS-VPN
* Target type: Virtual Private Gateway
* Select the CGW and VGW
* Routing: static - enter prefix: e.g. 172.31.0.0/16, 10.0.0.0/16

Download VPN configuration as OpenSwan type

STEP 3 - Enable route propagation for AWS VPC route table selecting the VGW (Management Account)
------------------------------------------------------------------------------------------------

STEP 4 - Configure OpenSwan on ON-PREMISES VPC EC2 Instance (Production Account)
--------------------------------------------------------------------------------

Run commands::

    sudo su
    yum install openswan -y
    nano /etc/sysctl.conf

Add::

    net.ipv4.ip_forward = 1
    net.ipv4.conf.all.accept_redirects = 0
    net.ipv4.conf.all.send_redirects = 0

    sysctl -p

Then open ipsec configuration for Tunnel1, and paste in the configuration.

    nano /etc/ipsec.d/aws.conf

This can be obtained from the file we downloaded last task of step 2.

Example::

    conn Tunnel1
            authby=secret
            auto=start
            left=%defaultroute
            leftid=<Public IP of OpenSwan/CGW>
            right=<Public IP of VGW - Tunnel 1>
            type=tunnel
            ikelifetime=8h
            keylife=1h
            phase2alg=aes128-sha1;modp1024
            ike=aes128-sha1;modp1024
            keyingtries=%forever
            keyexchange=ike
            leftsubnet=172.31.0.0/16
            rightsubnet=10.0.0.0/16
            dpddelay=10
            dpdtimeout=30
            dpdaction=restart_by_peer

IMPORTANT: REMOVE auth=esp from the code above if present

Next edit the pre-shared-key used to connect to the ipsec tunnel::

   nano /etc/ipsec.d/aws.secrets
   # Add single line: 54.169.159.173 54.66.224.114: PSK "Vkm1hzbkdxLHb7wO2TJJnRLTdWH_n6u3"

**The above can be found in the downloaded config file - MUST be updated with correct values**

Start and enable the ipsec service.
::

   systemctl start ipsec
   systemctl status ipsec

The connection should now be up
Test by pinging in both directions and use additional host
in on-premises DC to ping EC2 instance in AWS VPC (update route table)
