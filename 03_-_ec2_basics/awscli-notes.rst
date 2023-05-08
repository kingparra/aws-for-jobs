***************
 AWS CLI Notes
***************


Getting help
------------
``aws help``, ``aws ec2 help``


Using shorthand syntax with AWS CLI
-----------------------------------
``--option Key1=value1,Key2=vaule2`` ≡ ``--option '{"key1":"value1","key2":"value2"}'``.

``--option one two three`` ≡ ``--option "['one', 'two', 'three']"``.


Read in the value of an argument from a file
--------------------------------------------
Text files ``--option file://$path``.
Binary files ``--options fileb://$path`` (useful for ``--user-data``).


Generate a JSON skeleton of all of the possible options for a command
---------------------------------------------------------------------
``--generate-cli-skeleton``


Where configuration files live
------------------------------
``~/.aws/cli/aliases``, ``~/.aws/config``, ``~/.aws/credentials``

How to structure aws cli scripts
--------------------------------
https://alexharv074.github.io/2021/03/15/how-to-write-an-aws-cli-script-part-i-patterns.html
