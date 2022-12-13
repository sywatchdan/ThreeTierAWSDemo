
# Project Names
variable "vpc_name" {
  default = "Three Tier Demo VPC"
}
variable "naming_prefix" {
  default = "TT"
}

# AWS Regions & Availability Zones
variable "region_name" {
  default = "eu-west-2"
}
variable "availability_zone_1" {
  default = "eu-west-2a"
}
variable "availability_zone_2" {
  default = "eu-west-2b"
}

# Subnet Addressing
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "tt_public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}
variable "tt_public_subnet_2_cidr" {
  default = "10.0.2.0/24"
}
variable "tt_application_subnet_1_cidr" {
  default = "10.0.3.0/24"
}
variable "tt_application_subnet_2_cidr" {
  default = "10.0.4.0/24"
}
variable "tt_storage_subnet_1_cidr" {
  default = "10.0.5.0/24"
}
variable "tt_storage_subnet_2_cidr" {
  default = "10.0.6.0/24"
}

# Auto-Scaling EC2 Groups
variable "ec2_presentation_instances_desired" {
  default = 2
}
variable "ec2_presentation_instances_max" {
  default = 2
}
variable "ec2_presentation_instances_min" {
  default = 2
}
variable "ec2_application_instances_desired" {
  default = 2
}
variable "ec2_application_instances_max" {
  default = 2
}
variable "ec2_application_instances_min" {
  default = 2
}
variable "ec2_presentation_ami_id" {
    default = "ami-04706e771f950937f"
}
variable "ec2_application_ami_id" {
    default = "ami-04706e771f950937f"
}

# Amazon RDS
variable "rds_dbname" {
  default = "ttdb"
}
variable "rds_username" {
  default = "ttuser"
}
variable "rds_password" {
  default = "tt2dsf5shj"
}