terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region_name
}

# This is a Terraform project to create a simple Three Tier Architecture using AWS
# This will create:
# - VPC
# - Two public subnets across two availability zones, for the presentation layer
# - Two private subnets across two availability zones, for the application layer
# - Two private subnets across two availability zones, for the storage layer
# - An autoscaling EC2 group with instances running Apache web server in the presentation layer
# - An autoscaling EC2 group with instances running Docker in the application layer
# - A multi-AZ RDS using MySQL in the storage layer
# Appropriate security groups, routing tables, and NAT/IGW gateways are created

# Declarations are made in the following logical files:
# Variables/Naming - vars.tf
# Outputs - outputs.tf
# Networking/Subnets - networking.tf
# Security Groups - security.tf
# Storage/RDS - storage.tf
# EC2/Autoscaling/Load Balancers - ec2.tf
# Presentation EC2 Instance script - presentation_userdata.sh
# Application EC2 Instance script - application_userdata.sh

# Daniel Elwell, December 2022