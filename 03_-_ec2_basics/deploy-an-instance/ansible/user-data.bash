#!/usr/bin/env bash
sudo yum install -y openscap scap-security-guide httpd
sudo systemctl enable --now httpd
sudo oscap xccdf eval \
  --profile stig-rhel7-disa \
  --report /tmp/report.html \
  /usr/share/xml/scap/ssg/content/ssg-amzn2-xccdf.xml
sudo cp /tmp/report.html /var/www/html/
