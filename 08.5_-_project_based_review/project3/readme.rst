****************************************
 Project 3 - Setup IAM for Qualys Cloud
****************************************
Our Security Team has asked us to onboard all our
DEV/TEST accounts into a new security tool called
Qualys Cloud.

In order to do that we have been tasked with creating a
cross account role that will allow Qualys to run
security assessments on all our AWS workloads. For
consistency they have asked us to call the role
``QualysCloudViewRole``

In order for the Qualys agent to run on our accounts we
will require a role with a trust policy to an external
AWS account ``805950163170`` (Qualys account) and the
app requires that the trust policy includes an
``ExternalId`` ``US1-yewta6sr-kdhfsdhfsdjhjshf``.

The role should have the following policies attached:

* Security Audit (Managed Policy)

* Custom policy 1

  A policy that allows Qualys to get information from
  the Fargate service. It should include the following
  permissions on any possible fargate resource.

  ``eks:ListFargateProﬁles``
  ``eks:DescribeFargateProﬁle``

* Custom policy 2

  A policy that allows Qualys to get information from
  different services that are not covered by the
  security audit policy. It should include the
  following permissions

      ::

        "states:DescribeStateMachine",
        "elasticfilesystem:DescribeFileSystemPolicy",
        "qldb:ListLedgers",
        "qldb:DescribeLedger",
        "kafka:ListClusters",
        "codebuild:BatchGetProjects",
        "wafv2:GetWebACLForResource",
        "backup:ListBackupVaults",
        "backup:DescribeBackupVault",
        "ec2:GetEbsEncryptionByDefault",
        "ec2:GetEbsDefaultKmsKeyId",
        "guardduty:ListDetectors",
        "guardduty:GetDetector",
        "glue:GetDataCatalogEncryptionSettings",
        "elasticmapreduce:GetBlockPublicAccessConfiguration",
        "lambda:GetFunctionConcurrency",
        "ds:ListLogSubscriptions"

* Custom policy 3

  A policy that allows Qualys to get information from
  the API Gateway Service that is not covered by the
  security audit policy. It should allow
  ``apigateway:GET`` on the following resource
  ``arn:aws:apigateway:*::/restapis/*``
