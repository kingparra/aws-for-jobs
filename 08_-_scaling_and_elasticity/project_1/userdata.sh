#!/bin/bash
#Enable the epel-release
sudo amazon-linux-extras install epel
#Install and start Apache web server
sudo yum install -y httpd php
sudo systemctl start httpd
echo '<html><h1>Hello from Yellow Tail</h1></html>' \
  > /var/www/html/index.html
#Install CPU stress test tool
sudo yum install -y stress
