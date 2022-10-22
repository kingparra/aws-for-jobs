Module 8: Scaling and elasticity
********************************

DEMO Create a Launch Configuration - 04:14 mins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Name           : my-yellowtail-launch-configuration
Ami            : ami-046a961f907758d0d (the latest AmazonLinux AMI)
Instance type  : t2.micro
Security group : ASGSecurityGroup (with SSH allowed)


DEMO Create an Auto Scaling Group - 08:02 mins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Name                 : my-yellowtail-ASG
Launch configuration : my-yellowtail-launch-configuration
VPC                  : default
Group size:
* Desired : 3
* Min     : 1
* Max     : 5

DEMO Create a Simple Scaling Policy - 03:06 mins
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
**Auto scaling group -> my-yellowtail-ASG -> Automatic scaling**

Auto scaling group name: my-yellowtail-ASG

Scaling policy name: YellowTailSimpleScalingPolicy
Policy type: Simple scaling
CloudWatch Alarm:
  Name: YellowTailCPUOver80PercentAlarm
  Action: Add 2 capacity units and then wait 120 seconds before allowing another scaling activity

Scaling policy name: YellowtailSimpleScalingPolicy2
Policy type: Simple scaling
CloudWatch Alarm:
Name: YellowTailCPUUnder20PercentAlarm
Action: Remove 2 capacity units and then wait 120 seconds before allowing another scaling activity

# Shown briefly at timestamp 02:35, this policy is implicitly created by the web console.
Scaling policy name : Target Tracking Policy
Policy type         : Target tracking scaling
Execute policy when : As required to maintain average CPU utilization at 50%.
Action              : Add or remove capacity units as required.
Instances need      : 120 seconds to warm up before including in metric.
Scale in            : Enabled
