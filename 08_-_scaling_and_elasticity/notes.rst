**********************************
 Module 8: Scaling and Elasticity
**********************************


Outline
-------
* Scaling

  * Why is scaling important?

* Amazon EC2 auto scaling

  * Why is scaling important?

* Auto scaling groups

  * Auto scaling groups

* Scaling out vs scaling in

  * Scaling out vs scaling in

* How does amazon ec2 auto scaling work?

  * How does amazon ec2 auto scaling work?

* Implementing dynamic scaling

  * Implementing dynamic scaling

* Auto scaling groups demo

* AWS auto scaling

  * AWS auto scaling

    * What is AWS auto scaling?

* AWS auto scaling features and pricing

  * AWS auto scaling features and pricing

* AWS auto scaling benefits

  * AWS auto scaling benefits

* Decoupling your architecture

  * Monolithic vs decoupled architecture
  * Architecture

    * Tightly coupled
    * Loosely coupled

  * Decoupling in AWS

* Simple Queue Service (SQS)

  * Amazon SQS
  * Message queues for decoupling architectures
  * SQS message lifecycle
  * Achieve loose coupling with amazon SQS
  * Amazon SQS general use cases

* What is elasticity?

  * What is elasticity?

* Elastic load balancing

  * Elastic load balancing
  * Load balancer types
  * How does elastic load balancing work?
  * Elastic load balancing use cases
  * When to use an application, network, or classic LB
  * Load balancer monitoring
  * How to implement elasticity?

* Elastic load balancing demo


Definitions
-----------
Scalability

  The ability of a system to perform more work by increasing resources.

Elasticity

  A strategy for scaling where resources are added when demand increases
  and removed when demand decreases, automatically.


Questions
---------
* Where can I find the source code of a real application that
  uses SQS (or something like it) to help decouple it's architecture?
* What are the different scaling policy types?
* What are a few different way that I can write scaling policies in terraform?
* When should I use AWS Auto Scaling vs. Amazon EC2 Auto Scaling?

  * You should use AWS Auto Scaling to manage scaling for multiple
    resources across multiple services.

* How can I set up my launch template to "enable group metrics collection"?
