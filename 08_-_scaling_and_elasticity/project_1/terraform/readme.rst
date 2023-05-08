Project 1: Working with EC2 auto scaling and classic load balancers
*******************************************************************

Resource creation
-----------------
sg { name: web, description: "ELB for a webserver cluster", protocol: TCP port 80, source: anywhere }

lb { lbname: web, listener configuration: HTTP, subnets in these AZs: us-east-1{a,b,c,d,e,f}, security groups: web, health check: ping protocol: TCP, ping port: 80 }

sg { name: webserver-cluster, description: "Webserver security group", inbound rules: SSH and HTTP from anywhere }

keypair { name: YellowTailKeyPair }

lt { name: webserver-cluster, description: "Project launch template", ami: Latest AMZL ami, type: t3.micro, keypair: YellowTailKeyPair, Security groups: webserver-cluster, Detailed CloudWatch monitoring: Enable, Userdata: see userdata.sh }

asg { health check grace period: 120, monitoring: Enable group metrics collection within CloudWatch, scaling policies: Project scaling policy, desired: 1 minimum: 1 maximum: 5 }

scaling_policy { name: Project scaling policy, Metric type: Average CPU, Target value: 80, Instances need: 0, Disable scale in to create only a scale-out policy: unchecked }

outputs { lb_dns_name }

Testing the auto scaling group
------------------------------
Install and run stress on the instance: ``ssh $instance_ip bash -c 'sudo yum install -y stress && stress --cpu 2 --io 1 --vm 1 --vm-bytes 128M --timeout 5m'``. Then view the metric and wait five minutes.
