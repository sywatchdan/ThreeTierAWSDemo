#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker.service
systemctl enable docker.service