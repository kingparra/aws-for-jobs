Module 6: Security and Management Services
******************************************

Security, Identity, & Compliance services
-----------------------------------------
* **AWS Identity and Access Management (IAM)**

  AWS Identity and Access Management (IAM) is a web service for securely controlling access to AWS services. With IAM, you can centrally manage users, security credentials such as access keys, and permissions that control which AWS resources users and applications can access.

* AWS Artifact

  AWS Artifact is a web service that enables you to download AWS security and compliance documents such as ISO certifications and SOC reports.

* AWS Audit Manager

  AWS Audit Manager helps you continuously audit your AWS usage to simplify how you manage risk and compliance with regulations and industry standards. AWS Audit Manager makes it easier to evaluate whether your policies, procedures, and activities—also known as controls—are operating as intended. The service offers prebuilt frameworks with controls that are mapped to well-known industry standards and regulations, full customization of frameworks and controls, and automated collection and organization of evidence as designed by each control requirement.

* Amazon Cognito

  Amazon Cognito handles user authentication and authorization for your web and mobile apps. With user pools, you can easily and securely add sign-up and sign-in functionality to your apps. With identity pools (federated identities), your apps can get temporary credentials that grant users access to specific AWS resources, whether the users are anonymous or are signed in.

* **Amazon Detective**

  Amazon Detective makes it easy to analyze, investigate, and quickly identify the root cause of security findings or suspicious activities. Detective automatically collects log data from your AWS resources and uses machine learning, statistical analysis, and graph theory to help you visualize and conduct faster and more efficient security investigations.

* AWS Directory Service

  AWS Directory Service provides multiple ways to set up and run Microsoft Active Directory with other AWS services such as Amazon EC2, Amazon RDS for SQL Server, FSx for Windows File Server, and AWS IAM Identity Center (successor to AWS Single Sign-On). AWS Directory Service for Microsoft Active Directory, also known as AWS Managed Microsoft AD, enables your directory-aware workloads and AWS resources to use a managed Active Directory in the AWS Cloud.

* AWS Firewall Manager

  AWS Firewall Manager simplifies your AWS WAF administration and maintenance tasks across multiple accounts and resources. With AWS Firewall Manager, you set up your firewall rules just once. The service automatically applies your rules across your accounts and resources, even as you add new resources.

* Amazon Cloud Directory

  Amazon Cloud Directory is a cloud-native directory that can store hundreds of millions of application-specific objects with multiple relationships and schemas. Use Cloud Directory when you need a cloud-scale directory to share and control access to hierarchical data between your applications. With Cloud Directory, you can organize application data into multiple hierarchies to support many organizational pivots and relationships across directory information.

* **Amazon GuardDuty**

  Amazon GuardDuty is a continuous security monitoring service. Amazon GuardDuty can help to identify unexpected and potentially unauthorized or malicious activity in your AWS environment.

* AWS IAM Identity Center (successor to AWS Single Sign-On)

  IAM Identity Center provides one place where you can create or connect workforce users and centrally manage their access to all their AWS accounts, Identity Center enabled applications, and applications that support Security Assertion Markup Language (SAML) 2.0. Workforce users benefit from a single sign-on experience and can use the access portal to find all their assigned AWS accounts and applications in one place.

* **Amazon Inspector**

  Amazon Inspector is a security vulnerability assessment service that helps improve the security and compliance of your AWS resources. Amazon Inspector automatically assesses resources for vulnerabilities or deviations from best practices, and then produces a detailed list of security findings prioritized by level of severity. Amazon Inspector includes a knowledge base of hundreds of rules mapped to common security standards and vulnerability definitions that are regularly updated by AWS security researchers.

* Amazon Macie

  Amazon Macie is a fully managed data security and data privacy service. Macie uses machine learning and pattern matching to help you discover, monitor, and protect your sensitive data in Amazon S3.

* AWS Network Firewall

  AWS Network Firewall is a stateful, managed, network firewall and intrusion detection and prevention service for your virtual private cloud (VPC).

* AWS Resource Access Manager (AWS RAM)

  Use AWS Resource Access Manager (AWS RAM) to share resources you create in one AWS account with other accounts. If your account is part of an organization, then you can share your resources with all of the accounts in the organization, or with specific organizational units (OUs). Some resource types let you share with individual AWS Identity and Access Management (IAM) users and roles.

* **AWS Secrets Manager**

  Think hashicorp vault.

  AWS Secrets Manager helps you to securely encrypt, store, and retrieve credentials for your databases and other services. Instead of hardcoding credentials in your apps, you can make calls to Secrets Manager to retrieve your credentials whenever needed. Secrets Manager helps you protect access to your IT resources and data by enabling you to rotate and manage access to your secrets.

* **AWS Security Hub**

  AWS Security Hub provides you with a comprehensive view of the security state of your AWS resources. Security Hub collects security data from across AWS accounts and services, and helps you analyze your security trends to identify and prioritize the security issues across your AWS environment.

* AWS Shield

  DDos protection service.

* AWS WAF

  AWS WAF is a web application firewall that lets you monitor the HTTP and HTTPS requests that are forwarded to your protected web application resources.

* AWS trusted Advisor

  Reccomendations that help you follow AWS best practices.


What is IAM?
------------
IAM does two things: Identity, and Access Management.

Identity
^^^^^^^^
IAM handles authentication. Authentication happens over HTTP using a authorization request which comprises a request context and access credentials. At the end you get a session token. Think "PAM (pluggable authentication modules) for the cloud."

IAM allows you to split your AWS account into multiple identities (users, groups, roles). Think "user accounts for the cloud".

IAM allows princpals (users, workloads) to assume temporary identities (roles) using secure token service. Think "sudo for the cloud".

IAM also allows mappings between temporary identities (roles) in your account and identities from an external source. The external source may be a different AWS account with its own IAM users (cross-account access), or a directory service (federated access). Think "NSS+SSSD for the cloud".

Access management
^^^^^^^^^^^^^^^^^
IAM intermediates every API call you make. When you make a call, it is evalated against policies. With policies, you can control which <identities> are authorized to perform which <API actions> on which <resources>. You manage access in AWS by creating policies and attaching them to identities or resources. Think "SELinux for the cloud".

Logging
^^^^^^^
Logging is not a feature of IAM, (CloudTrail does that), but it is possible to log IAM transactions. This is pretty useful, and can be analyzed with other security services like Detective, Inspector, and GuardDuty.

Phew.

.. topic:: What is mandatory access control?

   MAC

   An access control policy that is uniformly enforced across all subjects and objects within the boundary of an information system. A subject that has been granted access to information is constrained from doing any of the following:

   (i) passing the information to unauthorized subjects or objects;
   (ii) granting its privileges to other subjects;
   (iii) changing one or more security attributes on subjects, objects, the information system, or system components;
   (iv) choosing the security attributes to be associated with newly-created or modified objects; or
   (v) changing the rules governing access control.

   Organization-defined subjects may explicitly be granted organization-defined privileges (i.e., they are trusted subjects) such that they are not limited by some or all of the above constraints.

Is IAM a type system for the AWS API? Is IAM a form of MAC? Is MAC a type system?


How to access IAM
-----------------
* Management console
* CLI
* SDK
* **IAM Query API** - A specialized API just for querying information.


Request
-------
When a principal tries to use the AWS Management Console, the AWS API, or the AWS CLI, that principal sends a request to AWS. The request includes the following information:

* Actions or operations
* Resources
* Principal
* Environment data - Information about the IP address, user agent, SSL enabled status, or the time of day.
* Resource data - Data related to the resource that is being requested. This can include information such as a DynamoDB table name or a tag on an Amazon EC2 instance.

AWS gathers the request information into a request context, which is used to evaluate and authorize the request.


Authorization: What actions are permitted?
------------------------------------------
Authorization is proving your have the authority to perform an action.

IAM uses a whitelist approach for access control decisions.
By default any action not explicitly allowed is denied.

To explicitly allow an action, you must write a policy.
**Policies** are JSON documents that encode what actions are
permitted, by who, on what resource, and under what conditions.


Policies and users
------------------
When you create an IAM user, they can't access anything in your account until you give them permission. You give permissions to a user by creating an identity-based policy.


Policies
--------

Structure of a policy document
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
::

  {
    "Version": ...,
    "Statement": [
      {
        "Sid":           ...,
        "Effect":        ...,
        "Principal":     ...,
        "Action":      [...],
        "Resource":      ...,
        "NotResource":   ...,
        "Condition":     ...,
      },
      ...
    ]
  }


Types of policies
^^^^^^^^^^^^^^^^^
The videos say there are two types of policies,

* **Identity-based policies**

  * managed (must be attached to an indentity)

    * AWS managed
    * Customer managed

  * inline (defined a resource inline)

* **Resource-based policies** (these happend to be inline, and there is only one type of Resource-based policy called a role trust policy. Trust policies define which principal entities can assume the role.)

But the docs mentions a few more, some of which come from different services
https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html

* Permissions boundaries (IAM guard-rail)
* Access control lists (found on S3 buckets, )
* Session policies (like permissions boundaries for sts federated users)
* Organizations SCPs (Account or org level guard-rail)


Advantages of ABAC over RBAC
----------------------------
* Less management of hierarchies
* fewer policies
* Granular permissions are possible
* Use attributes from your corporate directory


IAM Policy Evaulation
---------------------
The evaluation logic for a request within a single account follows these rules:

* By default, all requests are implicitly denied. (Alternatively, by default, the AWS account root user has full access.)
* An explicit allow in an identity-based or resource-based policy overrides this default.
* If a permissions boundary, Organizations SCP, or session policy is present, it might override the allow with an implicit deny.
* An explicit deny in any policy overrides any allows.

::

  <Explicitly denied?>
    +--|yes|--> [Deny]
    +---|no|--> <explicity allowed?>
                   +--|yes|--> [Allow]
                   +---|no|--> [Deny]

..
  Statements from the policies in https://www.youtube.com/watch?v=YQsK4MtsELU

  # Allow create role, but only with a specific permission boundary.
  # Allow attach managed policies but only to foles with a specific boundary.
  Effect: Allow
  Action: [ iam:CreatePolicy, ... ]
  Resource: "arn:aws:iam::12345678:policy/unicorns-*"

  Effect: Allow
  Action: [ iam:DetachRolePolicy, iam:CreateRolePolicy, iam:AttachRolePolicy ]
  Resource: "arn:aws:iam::12345678:policy/unicorns-*"
  Condition:
  - StringEquals:
      iam:PermissionsBoundary: arn:aws:iam:12345678:policy/region-restriction

  # The permissions boundary, region-restriction
  # Beware that some services are *global*
  Effect: Allow
  Action: [ "secretsmanager:*", "lambda:*", "s3:PutObject", "s3:GetObject", "s3:DeleteObject" ]
  Resource: "*"
  Condition:
  - StringEquals:
      aws:RequestedRegion: [ us-west-1, us-west-2 ]

  # Service control policy defined in AWS Organizations...  DenyUnapprovedActions
  Effect: Deny
  Action: [ "ds:*", "iam:CreateUser", "cloudtrail:StopLogging" ]
  Resource: [ "*" ]

  # Require specific tags when users create new resoruces
  Effect: Allow
  Action: [ ec2:RunInstances ]
  Resource: [ arn:aws:ec2:*:*:instance/* ]
  Condition:
  - ForAllValues:StringEquals:
      aws:TagKeys:
      - project
      - name
  - StringEquals:
      aws:RequestTag/project:
      - dorky                   # <--- "project" tag must have the value "dorky"
                                # but the name tag can be whatever you want
      aws:RequestedRegion:
      - us-west-1
      - us-west-2
 # a separate examle of
 # tag based access control...
 Condition:
   StringEquals:
     # PrincipalTag is a tag applied to our user (or principal)
     aws:PrincipalTag/Department: DBAdmins
     rds:db-tag/Environment: Production


Roles
-----

Lessons 4: AWS STS

Allows an entity to assume a role, using the sts:AssumeRole api action.

Externally authenticated users

User access the Identity broker --> Broker authenates the user --> Requests temp creds from STS --> Temp creds returned to application

Identity federation options:

* STS

  * public idps
  * custom identity broker app

* SAML
* Cognito


Lessons 5: Identity federation with an identity broker

1. User access broker
2. User authenticated to corp id store
3. Identity broker requests creds from sts
4. app receives creds and redirects user console

Identity federation using SAML

1. User navigates to URL
2. IdP auths user
3. Idp returns SAML Assertion to user
4. Assertion posted (via http/s) to the sign in endpoint
5. User is redirected to the console


CloudTrail
----------
CloudTrail is a monitoring service for the AWS API.
This of it as /var/log/audit for the cloud.

A record in CloudTrail is known as an event.
The default log retention is for 90 days worth of events.
There are differen kind of events.

* Management Events: Operations performed on resoruces.
* Data Events:
  Things like DB inserts, S3 object uploads, etc. Enabled only for data resources you specify. Charege at $0.10 per 100,000 events.
* Insights:
  Analyses your CloudTrail events to find unusual activity.
  Insight events are displayed on the insights page.
  $0.25 per 100,000 write management events analyzed.
