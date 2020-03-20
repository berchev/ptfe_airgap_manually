# Creating PTFE dedicated VPC
resource "aws_vpc" "ptfe_vpc" {
  cidr_block           = "172.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ptfe_vpc"
  }
}

#Creating gateway for specific VPC (In this way traffic from internet can go in/out of the VPC)
resource "aws_internet_gateway" "ptfe_gw" {
  vpc_id = aws_vpc.ptfe_vpc.id

  tags = {
    Name = "ptfe_gw"
  }
}

# Creating route table for specific VPC
resource "aws_route_table" "ptfe_route_table" {
  vpc_id = aws_vpc.ptfe_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ptfe_gw.id
  }

  tags = {
    Name = "ptfe_route"
  }
}

# Assign route table to specific VPC
resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.ptfe_vpc.id
  route_table_id = aws_route_table.ptfe_route_table.id
}

# All availability zones of the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Creating first subnet for the database
resource "aws_subnet" "first_ptfe_subnet" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.ptfe_vpc.id
  cidr_block        = "172.0.1.0/24"

  tags = {
    Name = "first_ptfe_subnet"
  }
}

# Creating second subnet for the database
resource "aws_subnet" "second_ptfe_subnet" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.ptfe_vpc.id
  cidr_block        = "172.0.2.0/24"

  tags = {
    Name = "second_ptfe_subnet"
  }
}

# Creating separate subnet for the ptfe instance
resource "aws_subnet" "third_ptfe_subnet" {
  availability_zone = data.aws_availability_zones.available.names[2]
  vpc_id            = aws_vpc.ptfe_vpc.id
  cidr_block        = "172.0.3.0/24"

  tags = {
    Name = "third_ptfe_subnet"
  }
}