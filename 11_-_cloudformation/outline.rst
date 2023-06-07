***************************
 Module 11: CloudFormation
***************************

* CloudFormation
* What is CloudFormation?

  An IaC tool for AWS like Terraform, but worse.

* Benefits

  * Management of dependencies between resources.
  * Resource lifecycle management.
  * Version control.
  * Automation.

* Stacks

  A stack implements and manages the group of resources outlined
  in your template, and allows the state and dependencies of
  those resources to be managed together. Think of it as an
  execution instance of your template.

* Templates

  A template is a declarative configuration file that describes
  the intended state of the resources you need to deploy your
  application. It's like a terraform module.

  Templates are written in JSON or YAML, and are divided into
  sections.

  Here is a YAML-formatted template fragment that shows all the
  sections.

  ::

    ---
    AWSTemplateFormatVersion: "version date"
    Description:
      String
    Metadata:
      template metadata
    Parameters:
      set of parameters
    Rules:
      set of rules
    Mappings:
      set of mappings
    Conditions:
      set of conditions
    Transform:
      set of transforms
    Resources:
      set of resources
    Outputs:
      set of outputs

  The only mandatory section is ``Resources``. The others are
  optional.

* Change sets

  A change set is a preview of changes that will be executed by
  stack operations to create, update, or remove resources. It's
  like "terraform plan". It shows what running a stack would do.

* Template: Format section

  The AWS CloudFormation template version that the template
  conforms to. Defaults to the latest version.

* Template: Parameters section

  Parameters are like input variables in Terraform.
  You are limited to 200 parameters per template.

  Docs here
  https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html

  Here's how you define a parameter::

    Parameters:
      InstanceTypeParameter:  # "logical name" or variable name
        Type: String          # manadatory
        Default: t2.micro
        AllowedValues:
          - t2.micro
          - m1.small
          - m1.large
        Description: Enter t2.micro, m1.small, or m1.large. Default is t2.micro.

  You can use the Ref intrinsic function to retrieve the value of a parameter.

  ::

    Ec2Instance:
      Type: AWS::EC2::Instance
      Properties:
        InstanceType:
          Ref: InstanceTypeParameter
        ImageId: ami-0ff8a91507f77f867

  The ``Ec2Instance.InstanceType`` property is assigned the
  value that ``InstanceTypeParameter`` refers to.

  There is an alternative syntax for the ``Ref`` function, where
  you don't need a semicolon.

  ::

    !Ref logicalName

* Template: Description section

  A text string that describes the template. This section must
  always follow the template format version section.

* Template: Metadata section

  Objects that provide additional information about the template.

* Template: Resources section

  Values to pass to your template at runtime (when you create or
  update a stack). **You can refer to parameters from the Resources
  and Outputs sections of the template.**

* Template: Outputs section
* Template: Reference parameters
* Template: General requirements for parameters
* Template: Rules section

  Rules are preconditions for parameters used in your stack.

  What is the anatomy of a rule?

  * condition (optional)
  * assertions (required)

  Rule-specific intrinsic functions

  * ``Fn::And``
  * ``Fn::Contains``
  * ``Fn::EachMemberEquals``
  * ``Fn::EachMemberIn``
  * ``Fn::Equals``
  * ``Fn::If``
  * ``Fn::Not``
  * ``Fn::Or``
  * ``Fn::RefAll``
  * ``Fn::ValueOf``
  * ``Fn::ValueOFAll``


* Template: Mappings section
* Template: Conditions section
* Template: Transform section
