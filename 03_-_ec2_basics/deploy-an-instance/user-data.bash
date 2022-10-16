#!/bin/bash
sudo bash -c '
yum install openscap scap-security-guide httpd -y
systemctl start httpd
systemctl enable httpd
oscap xccdf eval --profile stig-rhel7-disa --report /tmp/report.html /usr/share/xml/scap/ssg/content/ssg-amzn2-xccdf.xml
cp /tmp/report.html /var/www/html/
'
