Module 8: Scaling and elasticity
********************************


DEMO Create a Launch Configuration
----------------------------------


ASGSecurityGroup
^^^^^^^^^^^^^^^^
* Name: ASGSecurityGroup
* Allow port 22

my-yellowtail-launch-configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Name           : my-yellowtail-launch-configuration
* Ami            : ami-046a961f907758d0d (the latest AmazonLinux AMI)
* Instance type  : t2.micro
* Security group : ASGSecurityGroup (with SSH allowed)


DEMO Create an Auto Scaling Group
---------------------------------

my-yellowtail-ASG
^^^^^^^^^^^^^^^^^
* Name                 : my-yellowtail-ASG
* Launch configuration : my-yellowtail-launch-configuration
* VPC                  : default
* Group size:

  * Desired : 3
  * Min     : 1
  * Max     : 5

DEMO Create a Simple Scaling Policy
-----------------------------------
my-yellowtail-ASG
^^^^^^^^^^^^^^^^^

YellowTailCPUUnder20PercentAlarm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

YellowTailCPUOver80PercentAlarm
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

YellowTailSimpleScalingPolicy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Scaling policy name: YellowTailSimpleScalingPolicy
* Policy type: Simple scaling
* CloudWatch Alarm:

  * Name: YellowTailCPUOver80PercentAlarm
  * Action: Add 2 capacity units and then wait 120 seconds before
    allowing another scaling activity

YellowTailSimpleScalingPolicy2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* Scaling policy name: YellowtailSimpleScalingPolicy2
* Policy type: Simple scaling
* CloudWatch Alarm:

  * Name: YellowTailCPUUnder20PercentAlarm
  * Action: Remove 2 capacity units and then wait 120 seconds
    before allowing another scaling activity


Target Tracking Policy
^^^^^^^^^^^^^^^^^^^^^^
# Shown briefly at timestamp 02:35, this policy is implicitly
# created by the web console.

* Scaling policy name : Target Tracking Policy
* Policy type         : Target tracking scaling
* Execute policy when : As required to maintain average CPU
                        utilization at 50%.
* Action              : Add or remove capacity units as required.
* Instances need      : 120 seconds to warm up before including in metric.
* Scale in            : Enabled


Lesson 2: AWS SQS
-----------------

Decoupling your architecture
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Components of a system can be said to be tightly coupled or loosely coupled
with each other.

When components are decoupled they work in isolation of each other.
Decoupled components do not have knowledge of the
implementation details of other components.

https://www.wikiwand.com/en/Coupling_%28computer_programming%29


Lecture 2 Notes
---------------
* Fully managed message