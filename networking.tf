
# VPC
resource "aws_vpc" "tt_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

#Internet Gateway
resource "aws_internet_gateway" "tt_igw" {
  vpc_id = aws_vpc.tt_vpc.id
}

# Public Subnet AZ 1
resource "aws_subnet" "tt_public_subnet_1" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "${var.naming_prefix} public Layer Subnet 1"
  }
}

# Public Subnet AZ 2
resource "aws_subnet" "tt_public_subnet_2" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_public_subnet_2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "${var.naming_prefix} public Layer Subnet 2"
  }
}

# App Subnet AZ 1
resource "aws_subnet" "tt_application_subnet_1" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_application_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "${var.naming_prefix} Application Layer Subnet 1"
  }
}

# App Subnet AZ 2
resource "aws_subnet" "tt_application_subnet_2" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_application_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "${var.naming_prefix} Application Layer Subnet 2"
  }
}

# Storage Subnet AZ 1
resource "aws_subnet" "tt_storage_subnet_1" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_storage_subnet_1_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "${var.naming_prefix} Storage Layer Subnet 1"
  }
}

# Storage Subnet AZ 2
resource "aws_subnet" "tt_storage_subnet_2" {
  vpc_id                  = aws_vpc.tt_vpc.id
  cidr_block              = var.tt_storage_subnet_2_cidr
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "${var.naming_prefix} Storage Layer Subnet 2"
  }
}

#Storage Subnet group
resource "aws_db_subnet_group" "tt_storage_subnet_group" {
  subnet_ids = [aws_subnet.tt_storage_subnet_1.id, aws_subnet.tt_storage_subnet_2.id]
  tags = {
    Name = "${var.naming_prefix} Storage Subnet Group"
  }
}

# Route Table and Associations for Public Subnets to Internet
resource "aws_route_table" "tt_public_route" {
  vpc_id = aws_vpc.tt_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tt_igw.id
  }
  tags = {
    Name = "${var.naming_prefix} Route - Outbound to Internet"
  }
}

resource "aws_route_table_association" "tt_route_assoc_1" {
  subnet_id      = aws_subnet.tt_public_subnet_1.id
  route_table_id = aws_route_table.tt_public_route.id
}
resource "aws_route_table_association" "tt_route_assoc_2" {
  subnet_id      = aws_subnet.tt_public_subnet_2.id
  route_table_id = aws_route_table.tt_public_route.id
}

# Elastic IP Addresses for NAT Gateways
resource "aws_eip" "tt_eip_1" {
  vpc = true
}

resource "aws_eip" "tt_eip_2" {
  vpc = true
}

# NAT Gateway to sit in Public Subnet of AZ 1
resource "aws_nat_gateway" "tt_natgateway_1" {
  allocation_id = aws_eip.tt_eip_1.id
  subnet_id     = aws_subnet.tt_public_subnet_1.id
  tags = {
    Name = "${var.naming_prefix} NAT Gateway 1"
  }
}

# NAT Gateway to sit in Public Subnet of AZ 2
resource "aws_nat_gateway" "tt_natgateway_2" {
  allocation_id = aws_eip.tt_eip_2.id
  subnet_id     = aws_subnet.tt_public_subnet_2.id
  tags = {
    Name = "${var.naming_prefix} NAT Gateway 2"
  }
}

# Routing Tables and associations for NAT Gateways
resource "aws_route_table" "tt_natgateway_route_1" {
  vpc_id = aws_vpc.tt_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tt_natgateway_1.id
  }

  tags = {
    Name = "${var.naming_prefix} Route - NAT Gateway 1"
  }
}

resource "aws_route_table" "tt_natgateway_route_2" {
  vpc_id = aws_vpc.tt_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tt_natgateway_2.id
  }

  tags = {
    Name = "${var.naming_prefix} Route - NAT Gateway 2"
  }
}

resource "aws_route_table_association" "tt_natgateway_route_assoc_1" {
  subnet_id      = aws_subnet.tt_application_subnet_1.id
  route_table_id = aws_route_table.tt_natgateway_route_1.id
}

resource "aws_route_table_association" "tt_natgateway_route_assoc_2" {
  subnet_id      = aws_subnet.tt_application_subnet_2.id
  route_table_id = aws_route_table.tt_natgateway_route_2.id
}

