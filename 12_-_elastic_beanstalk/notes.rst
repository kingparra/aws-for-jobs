******************************
 Module 11: Elastic Beanstalk
******************************

  The more control you need, the less you can abstract
  away. ~ Some blogger

  First you learn the value of abstraction, then you
  learn the cost of abstraction, then you're ready to
  engineer. ~ Kent Beck


Elastic Beanstalk (EBS) is essentially a set of
managed deployment scenarios that you commonly
find for three-tier web apps. On the back-end
it uses CloudFormation to provision the resources.

The idea is that you only have to provide the code
for your app (and config for the http server).
The auto scaling, load balancing, software
deployment, os patching, and monitoring are
all taken care of by EBS.

Concepts
^^^^^^^^
* **Application** - A logical collection of EB components including environments, versions, and environment configurations.

* Application version - a labeled iteration of deployable code for a web app. This points to an S3 object.

* **Environment** - A collection of AWS resources running an application version. A stack{,set}.

* Environment tier - web server or worker.

* Environment configuration - a collection of parameters and settings that define how and its associated resources behave.

* Saved configuration - A template you can use as a starting point for creating unique environment configurations.

* Platform - A combination of OS, PL, runtime, web server, app server, and EB components.

Architecture models
^^^^^^^^^^^^^^^^^^^
* Single instance deployment

  * Comprised of an EIP, and instance, and a RDS master DB.

* Asg + Alb

  * Consists of an auto scaling group, an RDS master and standby, and an application load balancer.

Automatic deployment of updates can be accomplished
using a variety of deployment options, with varying
level of guaranteed availability.

Deployment policies
^^^^^^^^^^^^^^^^^^^
The "deployment policies" section of EBS controls the strategy of software
distribution to your nodes. Some of these are pretty interesting, and I think
that I should understand these deployment strategies independently of any
particular service.

* All at once

  This is the fastest deployment option, but the application will experience downtime.
  Ideal for quick iterations in development environments. Incurs no additional cost.

* Rolling update

  This deployment strategy reduces downtime at the cost of lowering capacity for some time.
  During a rolling update, some n number of instances (known as the bucket size) ceases to
  receive traffic while an in-place update is performed. Then they are brought back online.
  Rinse and repeat for all of the instances in your topology.

* Rolling update with additional batches

  This is like a rolling update, except that an extra bucket of instances is created to
  replace the capacity of buckets undergoing in-place update. After the update is complete,
  the extra instances are terminated.

* Immutable deployment

  New instances are created with a new ASG that lives along-side the existing ASG. Once the new
  instances provide a good health check to the load balancer, traffic is switched over to the new ASG.
  Then the old ASG is deleted. This is the most time consuming deployment option. Good for production
  workloads that need HA.

* Traffic splitting

  This is a canary test. You control which percentage of traffic goes to the old or new instances.

* Blue/Green deployment

  This is not a feature of elastic beanstalk, but a general deployment strategy that I should know.


Elastic beanstalk extensions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To provide an application to EB, you need to provide it as a zip
archive and make sure your code has an ``.ebextensions`` directory
in the root of the project.

This is a JSON configuration file that allows you to set parameters
for deployment using the ``option_settings`` key.
You can also use it to add resources such as RDS, ElasticCache, DynamoDB, etc.

Resources managed in the ``.ebextensions`` directory will be removed if the environment is
terminated.

EB cloning
^^^^^^^^^^
You can clone an environment with the exact same configuration as an existing one.
This is useful to deploy a test version of your app.

EB and RDS
^^^^^^^^^^
Since DBs typically outlive other resources it usually makes sense to deploy them separately.
If you launch the DB as part of your EB environment, it will live in the same CloudFormation
stack as the rest of the resources, which means it may subject to replacement if the template
gets updated.
