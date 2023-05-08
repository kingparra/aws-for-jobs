#!/usr/bin/env python3

import aws_cdk as cdk

from cdk.cdk_stack import CdkStack


# Create an app, add an instance of CdkStack to the app.
app = cdk.App()
default_profile = cdk.Environment(account="972171577695", region="us-east-1")
CdkStack(app, "cdk", env=default_profile)

app.synth()
