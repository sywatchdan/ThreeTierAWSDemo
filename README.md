# ThreeTierAWSDemo

This is a demonstration Terraform project to create a multi-tier architecture using AWS.

The following logical resources are created:
- A presentation layer, containing auto-scaliing EC2 instances running Apache web server
- An application layer, containing auto-scaling EC2 instances running Docker (ready for application code)
- A storage layer, containing an Amazon RDS database

Appropriate networking subnets, security groups, load balancers, and gateways are created. 

To use this, clone this repo, make changes to variables in vars.tf, and run
```
terraform init
terraform plan
terraform apply
```

## Pre-requisites
Terraform
AWS CLI
Understanding of AWS components
Understanding of Terraform
