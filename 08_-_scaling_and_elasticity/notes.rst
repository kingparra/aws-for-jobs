**********************************
 Module 8: Scaling and Elasticity
**********************************


Outline
-------
Scaling
  Why is scaling important?

Amazon EC2 auto scaling
  Why is scaling important?

Auto scaling groups
  Auto scaling groups

Scaling out vs scaling in
  Scaling out vs scaling in

How does amazon EC2 auto scaling work?
  How does amazon EC2 auto scaling work?

Implementing dynamic scaling
  Implementing dynamic scaling

Auto scaling groups demo

AWS auto scaling
  AWS auto scaling
    What is AWS auto scaling?

AWS auto scaling features and pricing
  AWS auto scaling features and pricing

AWS auto scaling benefits
  AWS auto scaling benefits

Decoupling your architecture
  Monolithic vs decoupled architecture
  Architecture
    Tightly coupled
    Loosely coupled
  Decoupling in AWS

Simple Queue Service (SQS)
  Amazon SQS
  Message queues for decoupling architectures
  SQS message lifecycle
  Achieve loose coupling with amazon SQS
  Amazon SQS general use cases

What is elasticity?
  What is elasticity?

Elastic load balancing
  Elastic load balancing
  Load balancer types
  How does elastic load balancing work?
  Elastic load balancing use cases
  When to use an application, network, or classic LB
  Load balancer monitoring
  How to implement elasticity?

Elastic load balancing demo


Definitions
-----------
Scalability

  The ability of a system to perform more or less work by
  adding or removing resources.

Elasticity

  A strategy for scaling where resources are added when demand
  increases and removed when demand decreases, automatically.

Cohesion

  The degree to which the elements inside a module
  belong together. A module with high cohesion
  contains elements that are tightly related to each
  other an united in their purpose. A module with
  low cohesion contains unrelated elements.

Decoupling your architecture
----------------------------
The videos seem to conflate two separate but related
notions: monolith vs microservices and tight
coupling vs loose coupling.

It is possible to have a loosely coupled monolith,
or a tightly coupled microservices architecture.

One term used for these loosely coupled monoliths is
"modulith", short for "modular monolith".

Still, a microservices architecture can be helpful in
achieving a loosely coupled application, because it
forces you to make the data dependencies between modules
explicit in order for them to go over the network.

Where it gets confusing is how the messages are
distributed and cached, which is what message
queueing systems like SQS and RabbitMQ are about.

Related but distinct terms:

* Coupling: loose coupling vs tight coupling.
* Cohesion: low cohesion vs high cohesion.
* Architecture: microservices vs service oriented architecture vs monolith.

Simple Queue Service (SQS)
--------------------------

Notes
^^^^^
SQS is a fully managed message queueing service.
It uses a pull mechanism.

Message are encrypted and stored until they're
processed and deleted. Messages can be up to 256KiB
in size in any format. Messages are stored per-region,
in multiple AZs.

The queue acts as a buffer between producers and
consumers. Think of it as a flow-control mechanism.
Is used to decouple applications and make them more
resilient.

You can restrict who can access the queue by IP
address.

Queues can be used to trigger auto scaling based on
number of messages in the queue.

Questions
^^^^^^^^^
What is a queue?

* A queue in SQS is a holding pool for messages that has a
  First-In First-Out access pattern.

  https://en.wikipedia.org/wiki/Queue_(abstract_data_type)

What is a message?

* Any arbitrary string, up to 256KiB in size.

What is a publisher?

What is a consumer?

How do messages get into the queue (enque)?

How are messages consumed from the queue (dequeue)?

What is the dead letter queue?

How is confidentiality implemented?

What are the limits on message size?

What are the limits on availability?

What are some example use cases for SQS?

What aspects of the service are the customers
responsibility?
