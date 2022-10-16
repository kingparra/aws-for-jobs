* What is a security group?

  A security group acts as a virtual firewall for your EC2 instances to control incoming and
  outgoing traffic.

* What is IAM?

  AWS is exceptionally strong in this area. Their service, called Identity and Access
  Management (IAM), defines not only users and groups but also roles for systems. A
  server can be assigned policies, for example, to allow its software to start and stop
  other servers, store and retrieve data in an object store, or interact with queues—
  all with automatic key rotation. IAM also has an API for key management to help
  you store secrets safely.

* What is a region?

  * A location that a cloud provider maintains data centers. Such as ``us-east-1``.

* What is an availability zone?

  * Collections of data centers within a region. Each region has multiple, isolated locations known
    as availability zones.

    https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html

* What is a VPS?

  * Virtual private server. A VM on a public cloud, controlled by you. An instance.

* What is a VPC?

  * Virtual private **cloud**.
    Define and launch AWS resources in a logically isolated virtual network
    Your own LAN in the cloud.

* What is the AWS shared responsibility model?

  It's a model of who has responsibility of which parts of the stack.

  https://aws.amazon.com/compliance/shared-responsibility-model/

  "Security in the cloud" vs "security of the cloud."

* What are AWS' foundational services? What does "foundational" mean in this context?

  What are the foundational cloud services?

  Compute: Compute services help you make the most of your data. They support research and big data
  processing. AWS compute services cover virtual machines, containers, serverless computing, and
  more. For example, Munich Leukemia Laboratory uses AWS for genome sequencing; using Amazon Elastic
  Compute Cloud (Amazon EC2), they were able to process sequencing runs in 30-40 minutes, versus
  10-12 hours before the cloud.

  Storage: AWS storage solutions provide reliable, scalable, and secure storage for backup, disaster
  recovery, and business continuity. For example, the Smithsonian Institution shared over 2.8
  million images stored in Amazon Simple Storage Service (Amazon S3) for public analysis and use.

  Database: AWS databases are built for different data models and use cases and offer speed,
  reliability, availability, and security. For example, the West Virginia State Police uses Amazon
  Relational Database Service (Amazon RDS) to automate data backup and recovery for a web
  application that supports law enforcement.
