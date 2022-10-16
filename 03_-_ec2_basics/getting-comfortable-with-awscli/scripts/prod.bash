#!/usr/bin/env bash
PHOSTNAME=$(place meta-data command to get public hostname value)

yum install -y httpd
systemctl start httpd
systemctl enable httpd
cat >> /var/www/html/index.html <<- EOF
	<h1> This is a prod server </h1>
	############################################
	<h2> The public hostname of this server is: $PHOSTNAME </h2>
EOF
