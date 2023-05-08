
# Setup
This goal of this project is to try as many ways of launching an instance as possible. At this point I've tried Terraform, Ansible (using a Boto3 plugin), awscli, and Pulumi. Next up is CDK.

CDK is like an abstraction-layer on top of CloudFormation. As Terraform is to CloudFormation, Pulumi is to CDK. With it, you can leverage the abstraction capabilities of general-purpose PLs to make *constructs*, which are high-level patterns of resource deployments.

This tools been the hardest for me to get started with, but it also has a huge library of existing code, and mindshare with AWS specialists.

At this point, I feel like the API provides a good building block for further abstraction, and the tools that I use on top of it doesn't matter too much. Things are different for other Cloud providers/services/APIs.

```
# Create a mutable container for our dev tools
$ toolbox create cdk
$ toolbox enter cdk

# Install javascript, python, and their respective language-specific package managers.
$ sudo dnf in -y nodejs npm python3 python3-pip

# Install the cdk cli utility, only use sudo if you're in a container!
$ sudo npm install -g cdk

# Create a project-local python environment to install packges to
$ python3 -m venv .venv
$ source .venv/bin/activate

# Install the python packages required to use the cdk libs
$ pip install -r requirements.txt

# Set up the backend storage for CloudFormation templates
$ cdk bootstrap aws://972171577695/us-east-1
````

Now the cdk cli tool is installed, you have your python libs. Run this command to synthesize a CloudFormation template from your CDK app.

```
$ cdk synth
```

There is also a very trivial test included that can be run like this:

```
$ pytest
```

If you like the template generated by `cdk synth` and your tests pass, you can deploy the template to a stack using:

```
$ cdk deploy
```

More here: https://docs.aws.amazon.com/cdk/v2/guide/work-with-cdk-python.html