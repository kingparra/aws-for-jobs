#!/usr/bin/env bash
sudo yum install openscap scap-security-guide httpd -y
sudo systemctl enable --now httpd
sudo oscap xccdf eval \
  --profile stig-rhel7-disa \
  --report /tmp/report.html \
  /usr/share/xml/scap/ssg/content/ssg-amzn2-xccdf.xml
sudo cp /tmp/report.html /var/www/html/
