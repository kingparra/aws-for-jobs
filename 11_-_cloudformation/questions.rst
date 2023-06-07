***********
 Questions
***********

What is CloudFormation?
-----------------------
CF is an IaC tool like Terraform, limited to AWS's API.

What is a _?
------------
* template

  Templates are source code files written in yaml or json.
  The content of the template is divided into sections.
  The resource section is the only mandatory section, and
  where you list infrastructure that you want to create.
  CloudFormation tries to infer the order that resources
  must be created in, and manages the lifecycle of every
  resource.

* stack

  A stack tracks the association of actual resources created
  from a template. This is like a terraform state file, but
  it uses t ags to keep track of things instaed of IDs. you
  can have multiple stacks per template. This is like having
  multiple runs of the same terraform source code from
  different repos.

* change set

  A change set is like a ``terraform plan``.
  It shows you have resources will change when you
  apply the changes you made to a template.

* StackSet

  A stack set lets you create stacks in multiple target
  accounts and regions using a single template.

What about policy as code, like sentinel?
-----------------------------------------
CloudFormation has ``cfn-guard``. There is also a linter, ``cfn-lint``.

Why may I want to use CloudFormation over Terraform?
----------------------------------------------------
Realistically, I wouldn't.
Unrealistically, here are some technically sound arguments.

* It's possible to set up one-click deployments with CF.
* CF tempaltes can be distributed on the AWS marketplace, whereas Terraform cannot.
* Anyone who has a SysOps Associate cert most likely knows some CloudFormation.
* CloudFormation has a graphical editor called Designer that seems
  nice for doing visual presentations of network topologies. (There
  are tools to do this with Terraform, which are nicer, but they
  are expensive.)
* It's easy to create resource groups from CloudFormation stacks.
* If you are using the CDK (cloud development kit), then your code will
  render into a CloudFormation template. So can CDK for TF. Pulumi
  can also generate CF templates. So it's a compilation target.
* You can limit the actions that an author is permitted to do using IAM.
* If you have existing secrets in AWS Parameter Store it's easy to use
  them from CloudFormation templates.

Modules
-------
Does CloudFormation have the concept of modules? Is there a central place
to publish and find modules, like the Terraform registry?
