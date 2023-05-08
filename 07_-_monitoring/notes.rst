AWS Monitoring
**************

CloudWatch Overview
-------------------
CloudWatch is part monitoring service and part log management system.
Think of it as a combination of zabbix and rsyslog.

[Paraphrased from Unix and Linux System Administration Handbook 5ed.]

Monitoring services ingest real-time data for running
systems. They can be used to create dashboards for an
at-a-glance indication of your systems health, or as a
source of information to kick off automated processes.

Log management systems typically:

1) Ingest logs from many sources.

2) Provided a structured interface for querying, analyzing,
   filtering and monitoring messages.

3) Manage the retention and expiration of messages so that
   information is kept as long as it is potentially useful or
   legally required, but not indefinitely.

Log management systems like CloudWatch or Elastic Stack
address the more complex problem of curating messages.

These tools feature such aids as graphical interfaces,
query languages, data visualization, alerting, and automated
anomaly detection.

* Monitors

  * resources
  * workloads

* Collects and tracks

  * standard metrics
  * custom metrics
  * logs

* Alarms

  * send notifications to an SNS topic

* Events

  * Define rules to match events and route them to functions
    or streams for processing

Metrics
-------
* Metrics are time-ordered data points. Think of a metric as
  a variable to monitor, and the data points as representing
  the values of that variable over time.
* Metrics are provided by many AWS services APIs or from an agent program.
* CloudWatch can aggregate these metrics into statistics.

EC2 Metrics
-----------

  * EC2 standard monitoring can send metrics every 5 minutes,
    detailed monitoring every 1 minute.
  * Memory utilization is not a built-in metric, but a custom metric.
  * You have to install an agent to gather and send custom
    metrics. (CloudWatch unified agent.)
  * Custom metrics can be published in different *resolutions*.

    * **Standard resolution** every minute.
    * **High resolution** every second.

Alarms
------
* Alarms are used to automatically initiate actions on your behalf.
* An alarm watches a single metric over a specified time
  period, and performs one or more specified actions, based
  on the value of the metric relative to a threshold over time.
* Alarms can trigger actions, such as:

  * EC2: reboot, stop, terminate, recover
  * Autoscaling action
  * Send a notification to a SNS topic
  * Trigger systems manager automation
  * Create an opsitem incident

* Alarms can be based on:

  * Static threshold (cpu > 60% for 5 min)
  * Anomaly detection (if cpu is higher than "usual", uses machine learning)
  * Metric math expression (a user-supplied math formula)

* When you create an alarm, you specify:

  * Namespace
  * Metric
  * Statistic: data aggregation over specified period (sum min max average ..)
  * Period: length of time (1, 5, 10, 30, or any multiple of 60 seconds)
  * Conditions: >, >=, ==, <=, <
  * Additional configuration
  * Actions

Create your first alarm from the CLI
------------------------------------
The following example uses the put-metric-alarm command to
send an SNS email message when CPU utilization exceeds 75
percent:

::

   aws cloudwatch put-metric-alarm \
     \
     `############## Send an alarm to MyCPUTopic #######################` \
     --alarm-name           cpu-yellow-trail                              \
     --alarm-description    'Alarm when CPU exceeds 75 percent'           \
     --alarm-actions        arn:aws:sns:us-east-1:111122223333:MyCPUTopic \
     \
     `################ when this ec2 instance ##########################` \
     --namespace            AWS/EC2                                       \
     --dimensions           "Name=InstanceId,Value=i-12345678"            \
     \
     `################ has %cpu > 75% ##################################` \
     --metric-name          CPUUtilization                                \
     --statistic            Average                                       \
     --threshold            75                                            \
     --unit                 Percent                                       \
     --comparison-operator  GreaterThanThreshold                          \
     \
     `############### for ten minutes ##################################` \
     --period               300                                           \
     --evaluation-periods   2                                             \

CloudWatch Dashboards
---------------------
How do you know when your app is down, or at capacity, or under capacity?

Monitoring and dashboards.

Dashboards are like a customizable heads-up-display for your infrastructure.
They're comprised of visualizations for different metrics that you select
and arrange. The idea is to make it easy as possible for a team to identify
the current state of a system. This is known as observability.

In CloudWatch, dashboards are a global service, so you can see metrics from
multiple regions at once.

The AdministratorAccess or CloudWatchFullAccess policies will give you access
to them.


CloudWatch events or EventBridge
--------------------------------
What is EventBridge?

* EventBridge intercepts event from AWS services, and
 optionally steams them to a destination.

* If there is CloudTrail integration, EventBridge can
 intercept any API call.

* EventBridge can be used to schedule automated actions that
 self-trigger at certain times using cron or rate expressions.

 * Common targets:

   * Compute: Lambda, Batch, ECS Task
   * Orchestration: Step functions (WorkFlow), CodePipeline, CodeBuild
   * Integration: SQS, SNS, Kinesis Data Streams, Kinesis Data Firehose
   * Maintenance: SSM, EC2 actions

CloudWatch Logs - Sources
-------------------------
Sources of log information for cloud watch includes (but is not limited to):

* SDKs
* CloudWatch Log Agent
* CloudWatch Unified Agent
* Elastic Beanstalk can help send logs from apps
* ECS sends logs from containers
* Lambda sends logs from functions
* VPC flow logs
* API Gateway
* CloudTail logs based on filter(s)
* Route53 DNS queries

The agent program for custom metrics, CloudWatch Unified
Agent, can be installed either on instances or on-prem
machines.

CloudWatch Logs - Features
--------------------------
Log groups: You can organize logs into groups. It can be
given any name you like, most commonly after an application.

Log stream: instances within an application / log files / container.

Expiration policies: You can set log expiration policies, up to 120 months.

Logs can be encrypted using KMS.

Logs can be sent to:

* S3
* Kinesis Data Streams
* Kinesis Data Firehose
* Lambda
* ElasticSearch through a Lambda integration

CloudWatch logs metrics filters and insights
--------------------------------------------
You can use filter expressions to query CloudWatch.

For example, you can find records with a specific IP addr, or count
how many occurrences of the string "ERROR" are in your logs.

Metric filters can be used to trigger alarms.


CloudWatch Logs - S3 Export
---------------------------
In order to export logs to S3, the buckets must be encrypted with
AES-256 (SSE-S3) not SSE-KMS.

Log data may take up to 12 hours to become available to then be
ready to be exported.

The API call is CreateExportTask.


CloudWatch Logs Agent and CloudWatch Unified Agent
--------------------------------------------------
The agent programs are installed on an OS, so they're typically
used from EC2 instances or on-prem servers.

CloudWatch Logs Agent is the old version of the agent.

CloudWatch Unified Agent is a newer version of the agent.
It collects more system-level metrics such as RAM, process
information, etc. The unified agent can be configured using
the SSM parameter store.

In order to send logs to Kinesis, you have to install a separate
agent.


Simple Notification Service (SNS)
---------------------------------
SNS is a fully managed pub/sub messaging service.

SNS uses a push mechanism.

There are two types of topics: **standard** and **FIFO**.

The "event producer" only sends messages to one topic.

Any number of "event receivers" (subscriptions) can listen to the
SNS topic notifications.

Each subscriber to the topic will get the message.

You can have up to 10,000,000 (ten million) subscriptions per topic.

You can up to 100,000 (one hundred thousand) topics.


SNS Integration
---------------
SNS integrates with a lot of AWS services.

* CloudWatch (for alarms)
* Auto scaling group notifications
* S3 (on bucket events)
* CloudFormation templates (if a stack fails to build)
* ...and many more...

SNS Benefits
------------
* Modernize and decouple your applications
* Send messages directly to million of users
* Reliably deliver messages
* Automatically scale your workload
* Ensure accuracy with **message ordering** and **deduplication**.
* Simplify your architecture with message filtering.

SNS Supported transport protocols
---------------------------------
Email, JSON, HTTP(S), SMS, SQS, Lambda functions.

SNS - How does it work?
-----------------------
Publish topic
* Create a topic
* Create one or more subscriptions

Encryption:
* In-transit encryption using TLS (for API transactions over HTTPS)
* At-rest encryption using KMS keys
* Client-side encryption if the client wants to perform encryption itself ????

Access controls:
* IAM policies
* SNS access policies are useful for cross-account access to
  topics or allowing other services to write to a SNS topic.

SNS Pricing
-----------
Topics: Based on the number of: published messages, subscribed
messages, and the respective amount of payload data.

I won't bother listing the pricing details because I'm sure to
forget it and should use a price calculator anyways.


SNS - Create a topic from the CLI
---------------------------------
::

  aws sns create-topic --name my-yellow-trail-topic
