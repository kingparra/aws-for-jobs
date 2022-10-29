Project 1: Working with  EC2 Auto Scaling and Classic Load Balancer
*******************************************************************
The project description pdf explains how to create each of these
by hand in the web console. That's too slow. Here's a summary to
make it easier to automate.

::

  client --> ELB ---> instances <---created-by-- ASG w LC



Elastic load balancing
----------------------
Tag everything with ``mod8_project1_${random_id}``

Security group
^^^^^^^^^^^^^^
name: web
description: "ELB for a webserver cluster"
source: anywhwere


EC2 Load balancer
^^^^^^^^^^^^^^^^^
lbname: web
listener configuration: HTTP
subnets in these AZs: us-east-1{a,b,c,d,e,f}
security groups: web
health check:
* ping protocol: TCP
* ping port: 80



Launch template
---------------
Security group
^^^^^^^^^^^^^^
name: webserver-cluster
description: "Webserver security group"
inbound rules:
* Allow SSH from anywhere
* Allow HTTP from anywhere


Keypair
^^^^^^^
name: YellowTailKeyPair

Launch template
^^^^^^^^^^^^^^^
name: webserver-cluster
description: "Project launch template"
ami: Latest AMZL ami
type: t3.micro
keypair: YellowTailKeyPair
Security groups: webserver-cluster
Detailed CloudWatch monitoring: Enable
Userdata: see userdata.sh



Auto scaling group
------------------

Auto Scaling Group
^^^^^^^^^^^^^^^^^^
name: webserver-cluster
configure settings: Adhere to launch template
subnets in these AZs: us-east-1{a,b,c,d,e,f}
load balancing: Attach to an existing load balancer "web"
health check type: ELB
health check grace period: 120
monitoring: Enable group metrics collection within CloudWatch
scaling policies:
* Project scaling policy
desired capacity: 1
minimum capacity: 1
maximum capacity: 5

Scaling policy
^^^^^^^^^^^^^^
Scaling policy name: Project scaling policy
•Metric type: Select Average CPU utilization
•Target value: 80
•Instances need: 0
•Disable scale in to create only a scale-out policy: unchecked


Output variable
^^^^^^^^^^^^^^^
DNS NAME OF THE LOADBALANCER


Testing the auto scaling group
------------------------------
::

  # This is psuedo-code

  ssh $instance_ip

  > test "$(which stress)" = /usr/bin/stress

  > stress --cpu 2 --io 1 --vm 1 --vm-bytes 128M --timeout 5m

  > wait $((5*60)) # five minutes

  > # view the monitoring graph of the instance
