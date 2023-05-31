*****************
 Systems Manager
*****************


First glance at Systems Manager
-------------------------------
Systems manager is the operations hub for your apps and resources.

* Quick setup

* Operations management

  {Explorer, OpsCenter, CloudWatch Dashboard, Incident manager}

* Application management

  {Application Manager, AppConfig, Parameter store}

* Change management

  {Change manager, Automation, Change calendar, Maintenance windows}

* Node management

  {Fleet manager, compliance, inventory, hybrid activations, session manager,
   run command, state manager, patch manager, distributor}

* Shared resources

  {Documents}


Questions
---------
* What are the most frequently used features of SSM?
* What tasks will I most likely be asked to perform through SSM?
* What should I care about?

* Why would I use SSM instead of an equivalent (or better!)
  software package for whichever feature I'm interested in.

  It seems like there are things for each of these packages.

  One possible advantage of SSM is that it can draw from
  many AWS services. But I wonder about the pricing.


What is systems manager?
------------------------
Think of SSM as a combination of monitoring dashboard,
command execution center (configuration management), and
ticketing system, all in one. SSM operates on groups of
resources.

The soundbite version is: "Group your resources. View
insights. Take action."

The "groups or resources" are actually created using
the API of a different service, called "Resource Groups".
Resource groups are independent of but related to systems
manager.

What facilities does systems manager provide?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The left-hand side of the Systems Manager page in the web
has a lot of services! They are grouped into the following
categories:

* Operations management
* Application management
* Change management
* Node management
* Shared resources

Operations management
^^^^^^^^^^^^^^^^^^^^^
The thing that all of the operations management have in
common is this: They help you find out the current state of
your resources.

Application management
^^^^^^^^^^^^^^^^^^^^^^
Application manager lets you operate on CloudFormation
stacks. AppConfig and Parameter store are for application
config data and secrets management, respectively.

Change management
^^^^^^^^^^^^^^^^^
I'm going to make a grossly inaccurate generalization here.
This group is all about scheduling changes to existing
running OS or App installs. Changes may go through an
approval and review process. You can schedule maintenance
windows when the service isn't being used. The changes may
be stated as config management runbooks.

Cough cough self-serve infra changes reduce bottlenecks
cough cough lean manufacturing cough.

Node management
^^^^^^^^^^^^^^^
This group is all about centralized command and control.
You can also do inventorying and check for compliance.
Features in this group depend on an agent program, SSM
Agent, being installed on the node.


Operations management
---------------------
* Explorer
* OpsCenter
* CloudWatch Dsahboard
* Incident Manager


