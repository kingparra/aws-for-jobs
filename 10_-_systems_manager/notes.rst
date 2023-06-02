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
* CloudWatch dashboard
* Incident manager

OpsCenter
^^^^^^^^^
This service aggregates and normalizes messages about
operational issues. These are called OpsItems.

OpsItems come from many services, including AWS Config
changes, CloudWatch Alarms, CloudFormation Stack
information, and more.


Application management
----------------------
* Application manager
* AppConfig
* Parameter store

Application manager
^^^^^^^^^^^^^^^^^^^
It seems like this feature tries to group resources
based on many criteria, so you can manage them as a
unit.

Some possible criteria for grouping include: CloudFormation stack
name, ECS cluster, EKS, or AWS Launch Wizard.


Once you have an "application", you can manage it as a group.
You can also view operations info on them.

------- verbatim copy of the slides ----------------

Helps you investigate and remediate issues with your resources in
the context of your applications.

You can discover and/or define you application components,
view operations data in the context of an application,
and perform remedial actions such as patching and running
automation runbooks.

You can use application manager to view operational data on your
existing clusters in EKS clusters.

An application is a logical group of resource that you want to
operate on as a unit.

When you choose get started, application manager automatically
imports metadata about your resources that were created in other
services or systems manager capabilities.

Resources are displayed in the following predefined categories:

* CloudFormation stacks
* EKS clusters
* launch wizard

After import completes you can view operations information about
your resources in these predefined application categories.

..it turns out I can type at speaking speed...

------------------------------------------------------------

* Is Application Manager accessible from the command-line?

* When would I use Application manager rather than creating a
  custom dashboard on CloudWatch?

* What is an OpsItem, really?


AppConfig
^^^^^^^^^
AppConfig is a SaaS that lets you validate uploaded config files.
Misconfiguration is a leading cause of outages, so validating
config files is a valuable practice.

I've been thinking about this for a while, and I think I'd like
to see a rules system for config files that lets you define
relationships between fragments of the config. Think "strongly
typed AST for config files, with functions between the types
defining relationships".

Parameter Store
^^^^^^^^^^^^^^^
This is like HashiCorp vault. You can put sensitive info in here
and it will let you assign permissions to it. You can view who
accessed the info and when the accessed it. Access to sensitive
info is through an API. This is useful for separating passwords
and other sensitive details from your source code. Instead of
hardcoding passwords or using environment variables, you place
API calls to parameter store there.


An example of creating a new parameter with awscli::

  aws ssm put-parameter \
    --name $n \
    --value $v \
    --type String \
    --tags "Key=$tag_key,Value=$tag_value"

Change management
-----------------

Automation
^^^^^^^^^^
Tabs: Executions, Integrations, Preferences.

The SSM agent has it's own playbook format.
You can use it to run commands, call API methods,
or run python/powershell scripts.

Automation has some change management features.
You can schedule playbook execution in a maintenance window.
You can require approvals for actions within the playbook.

Components:

* Automation book
* Automation action
* Automation quota
* Automation queue quota
* Rate control automation quota
* Rate control automation queue quota

Playbooks are SSM documents of type automation.


Node management
---------------
* Fleet manager
* Compliance
* Inventory
* Hybrid activations
* Session manager
* Run command
* State manager
* Patch manager
* Distributor

The most useful services seem to be Run Command and Session Manager.
Distributor is a way to install a payload on many nodes at once. Usually some form of agent.
