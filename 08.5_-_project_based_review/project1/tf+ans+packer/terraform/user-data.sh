#!/usr/bin/env bash
yum update -y
aws s3 sync s3://yt-websites-2023/energym-html/ /var/www/html/
