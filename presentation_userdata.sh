#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Welcome to the Apache Server on the Three Tier AWS Demo" > /var/www/html/index.html