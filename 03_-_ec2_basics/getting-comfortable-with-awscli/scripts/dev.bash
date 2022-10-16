#!/bin/env bash
PHOSTNAME=$(curl 'http://169.254.169.254/latest/meta-data/hostname')

yum install -y httpd
systemctl start httpd
systemctl enable httpd
cat >> /var/www/html/index.html <<- EOF
	<h1> This is a dev server </h1>
	############################################
	<h2> The public hostname of this server is: $PHOSTNAME </h2>
EOF
