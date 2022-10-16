What is IAM?
------------
Everything that you do on AWS is implemented as an API call.
IAM lets you write policies for users and groups on those API calls.


Essential components
---------------------
* user
* group
* policy
* role


Authentication
--------------

Programmatic authentication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* access key id
* secret access key

Web console authentication
^^^^^^^^^^^^^^^^^^^^^^^^^^
* account ID
* username
* password
* MFA


Authorization
-------------
Use POPL. Approach writing policies as creating a whitelist.


Policies
--------
Identity based: Attached to a user, group, or role.

Resource based: Attached to a resource.

Deny statements take precedence over allow statements.
