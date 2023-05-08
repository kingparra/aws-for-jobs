#!/usr/bin/env bash

aws autoscaling describe-auto-scaling-groups \
  --output json \
| jp "AutoScalingGroups[].{
      AsgName: AutoScalingGroupName,
      LbName: LoadBalancerNames | [0]
      }
     "

