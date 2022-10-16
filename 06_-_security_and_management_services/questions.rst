* What is IAM?

  Manage access to services and resources.

  With IAM, you can specify who or what can access services and
  resources in AWS, centrally manage fine-grained permissions,
  and analyze access to refine permissions across AWS.

* What are the key abstractions?

  * entity
  * identity - A user, group, or role.
  * resource - Entities you create in AWS other than identities.
  * policy - 
    A collection of statements which determine whether
    an action on a resource is allowed or denied.
  * role
  * group
  * user

* What are the different categories of policies?

  * identity-based

    * managed
    * inline - attached directly to a identity

  * resource-based

* How can you allow a user the capability to assume a role?

  You attach a policy to the user that allows them to
  use the STS ``AssumeRole`` action.

  Here's an example policy to do that (backticks indicate a JS
  template string)::

    {
      "Version": "2012-10-17",
      "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": `arn:aws:iam:{ACCOUNT_ID}:role/RoleName`
      }
    }
