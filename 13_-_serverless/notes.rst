***********************
 Module 13: Serverless
***********************


ToC
---
* Serverless
* Introducing microservices

  * What are microservices?

* Monolithic vs microservice applications
* Characteristics of microservices
* Serverless architecture

  * What does serverless mean?
  * Benefits of serverless
  * Principles of serverless
  * AWS serverless offerings

* Building serverless architectures with Lambda

  * Lambda
  * How does lambda work?
  * Lambda functions
  * Lambda integrations
  * Anatomy of a lambda function
  * Lambda function configuration and billing

* Extending serverless architectures with API Gateway

  * What is an API?
  * What is a web API?
  * Web APIs
  * API methods
  * API gateway
  * API gateway security
  * API gateway common architecture example

* Serverless mobile backend example


Serverless
----------

What is the microservices architecture?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Imagine that every module in your application has been
extracted out to a separate web service application.
Each service receives inputs as API calls over the
network. Services may have a separate repos. Those
repos may be in different languages, use different tech
stacks, and have different release cycles.

I found these videos helpful:

* https://www.youtube.com/watch?v=lTAcCNbJ7KE
* https://www.youtube.com/watch?v=rv4LlmLmVWk

What is serverless computing?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
In serverless, you pay for the execution time of your code.
You don't have access to the underlying infrastructure.
This is ideal for scenarios where you need to scale up
rapidly, and scale down to zero when not in demand.

Why do devs want serverless?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"I don't want to pay when my workload is idle."
"I only want to write business logic."
"I want my application to scale on its own."

What are the inputs to a function in lambda?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``event`` and ``context``

``event`` is the unpacked body of a http transaction with a JSON load,
deserialized into native data types.

``context`` is an object that contains the following information:
``['aws_request_id', 'client_context', 'function_name', 'function_version',
'get_remaining_time_in_millis', 'identity', 'invoked_function_arn', 'log',
'log_group_name', 'log_stream_name', 'memory_limit_in_mb' ]``

What is the entry-point to a program in lambda?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Under **runtime settings** you will see an option
named **handler**. This is the module and function
name of the handler function that takes an ``event``
and ``context``.


Lambda functions concepts
-------------------------
* Function

* Trigger:

  Something that invokes a Lambda function. May include
  AWS services that you configure, and event source
  mappings. An event sour mapping is a resource in
  Lambda that reads items from a stream or queue and
  invokes a function.

* Event:

  A JSON blob. The runtime converts the event to an
  object and passes it to your function code.

* Execution environment:

  A container or micro-vm.

* Instruction set architecture

* Deployment package

* Runtime:

  The language interpreter/compiler and libs.
  The machinery required to relay invocation
  events to your handler function.

  You can build your own runtime.

* Layer:

  A zip archive that can contain additional libs, data,
  config, or a custom runtime. You can include up to
  five layers per function. Think of it as a layer in a
  container image.

* Extension

* Concurrency: The number of requests your function
  is serving at any given time. The current number of
  execution instances of your function.

* Qualifier: A tag used to constrain which version of
  your function to execute.

* Destination: A destination is where you send events
  from an asynchronous invocation.


Lambda execution environment
----------------------------
The functions runtime communicates with Lambda using the Runtime API.

Create a function from a zip file::

  aws lambda create-function --function-name myFunction \
    --runtime go1.x \
    --handler main \
    --role arn:aws:iam::123456789012:role/service-role/my-lambda-role \
    --zip-file fileb://myFunction.zip

    # If your code is in a bucket, rather than stored locally, use --code rather than --zip-file
    # --code S3Bucket=myBucketName,S3Key=myFileName.zip,S3ObjectVersion=myObjectVersion

Update the code for that function::

  aws lambda update-function-code \
    --function-name myFunction \
    --zip-file fileb://myFunction.zip

Set an environment variable for a lambda function::

  aws lambda update-function-configuration --function-name my-function \
    --environment "Variables={BUCKET=my-bucket,KEY=file.txt}"

...and view it::

  aws lambda get-function-configuration --function-name my-function

Invoke a function::

  aws lambda invoke \
    --function-name my-function \
    --cli-binary-format raw-in-base64-out \
    --payload '{"key1": "value1", "key2": "value2", "key3": "value3"}' \
    output.txt
