#!/usr/bin/env bash


# https://advancedweb.hu/cloudformation-cli-workflows/

# Create a template, which is a declaritive configuration file.
vim template.yaml

# Create a group of resources from your template, known as a stack.
# This is like terraform apply, but you need to name the stack.
aws cloudformation create-stack \
  --template-body file://template.yaml \
  --stack-name YourFancyStackName

# Create a change-set, which is a diff of what applying your updated template will
# do to your existing stack. Like terraform plan, but you need to name the stack,
# the template, and the changeset/plan.
aws cloudformation create-change-set \
  --template-body file://templatev2.yaml \
  --change-set-name ProposedChangesToYourFancyStackName \
  --stack-name YourFancyStackName

# View the change set. Unlike terraform plan, this is a separte step.
aws cloudformation describe-change-set \
  --change-set-name "$arn" \
  --query "Changes[].ResourceChange" \
  --output yaml

# To view the events that are generated when creating a stack
aws cloudformation describe-stack-events \
	--stack-name "$stack"


