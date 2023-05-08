#!/usr/bin/env bash
$ aws ec2 describe-instances \
  --filters Name=tag:"$1",Values="$2"
