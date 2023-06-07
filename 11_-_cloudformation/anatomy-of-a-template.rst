***********************
 Anatomy of a template
***********************
Templates are YAML or JSON documents divided into sections.
Each section contains different categories of information.
A section roughly corresponds to a type of terraform block.

If you want to read the YAML spec, here it is: https://yaml.org/spec/1.2.2/
Here is a cheat-sheet https://learnxinyminutes.com/docs/yaml/.

Sections:

* ``AWSTemplateFormatVersion``
* ``Description``
* ``Metadata``
* ``Parameters`` - input variables go here
* ``Rules``
* ``Mappings`` - key:value data structures go here
* ``Conditions``
* ``Transform`` - Use Lambda functions to macro-process and transform your template.
* ``Resources`` - This is the only mandatory section. It's where you define your infrastructure.
* ``Outputs`` - outputs to display go here


Parameters
----------
Here's an example of a parameter definition::

  Parameters:

    InstanceTypeParameter:
      Type: String
      Default: t2.micro
      AllowedValues:
        - t2.micro
        - m1.small
      Description: Type to use for the instances.

    ...

Each parameter definition corresponds to a web form that the user can fill out.

To use a variable, you can't access the name directly.
You have to deference the value of a parameter, using the ref function.
::

  !Ref ParameterName

You have a soft limit of 200 parameters.

Parameters have to be declared and referred to in the same template.

You can retrieve parameters from SSM Parameter Store.


Rules
-----
This section validates a parameter or combination of parameters.

The rules section has some intrinsic functions for relational operations and operations on
collections of bools.

* ``Fn::And``
* ``Fn::Contains``
* ``Fn::EachMemberEquals``
* ``Fn::EachMemberIn``
* ``Fn::If``
* ``Fn::Or``
* ``Fn::Equals``
* ``Fn::Not``
* ...and many more...

Here's are two example rules, to give you an idea of their structure.
::

  Rules:

    SubnetsInVPC:
      Assertions:
        - Assert:
            'Fn::EachMemberEquals':
              - 'Fn::ValueOf':
                  - Subnets
                  - VpcId
              - Ref: VpcId
          AssertDescription: All subnets must in the VPC

    ValidateHostedZone:
      RuleCondition: !Equals
        - !Ref UseSSL
        - 'Yes'
      Assertions:
        - Assert: !Not
            - !Equals
              - !Ref ALBSSLCertificateARN
              - ''
          AssertDescription: ACM Certificate value cannot be empty if SSL is required
        - Assert: !Not
            - !Equals
              - !Ref HostedZoneName
              - ''
          AssertDescription: Route53 Hosted Zone Name is mandatory when SSL is required

The assertion is a mandatory part of a rule.
The optional rule-condition determines when to evaluate a rule.


Mappings
--------
Mappings is a section where you can define key:value data structures.
Who thought dividing data structures into sections was a good idea?
Honestly.

An example::

  Mappings:
    AWSAMIRegionMap:
      AMI:
        AMZNLINUXHVM: amzn-ami-hvm-2017.09.1.20171120-x86_64-gp2
      ap-northeast-1:
        AMZNLINUXHVM: ami-da9e2cbc
      ap-northeast-2:
        AMZNLINUXHVM: ami-1196317f
      ap-south-1:
        AMZNLINUXHVM: ami-d5c18eba

To retrieve a value from ``AWSAMIRegionMap``, use ``Fn::FindInMap``.


Conditions
----------
What if you only want to create a resource when some condition is true?
You create a condition in the conditions section, and then refer to it
in the resources section, like so:

::

  ...
  Condition:
      isProduction: !Equals [ !Ref environment, production]
  ...
  Resources:
      instance0:
          Type: AWS::EC2::Instance
          Condition: isProduction
          Properties:
              ...
  ...


Transform
---------
This section is where macro pre-processing happens.
Macros are computed with lambda functions.
I have no idea how this works, but if I get stuck
actually using CloudFormation for anything serious,
I should look into it.

::

  ...
  Transform:
    - MyMacro
    - 'AWS::Serverless'
  ...
  Resources:

    Wait Condition:
      Type: 'AWS::CloudFormation::WaitCondition'

    MyYellowTailBucket:
      Type: AWS::S3::Bucket
      Properties:
        BucketName: MyYellowTailBucket
        Tags: [{“key” : “value”}]
        CorsConfiguration : []

    MyYellowTailInstance:
      Type: 'AWS::EC2::Instance'
      Properties:
        ImageId: 'ami-456'
  ...


Outputs
-------
Here's where you put your output variables.
There is a soft limit of 200 outputs.

Example::

  Outputs:
    BackupLoadBalancerDNSName:
      Description: The DNSName of the backup load balancer
      Value: !GetAtt BackupLoadBalancer.DNSName
      Condition: CreateProdResources
    InstanceID:
      Description: The Instance ID
      Value: !Ref EC2Instance

See the ``!Ref`` and ``!GetAtt`` functions?
Those are important. Look them up. Also look up ``!Sub``.


Other sections
--------------
Except for the resources section,
the other sections aren't important.
Look them up when you need to.
