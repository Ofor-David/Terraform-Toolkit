# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# VPC
resource "aws_vpc" "my-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  
  tags = {
    Name = "my-vpc"
  }
}

# subnets
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.aws_az

  tags = {
    Name = "subnet-1"
  }
}
# igw
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "my-vpc-igw"
  }
}
#rtb
resource "aws_route_table" "my-vpc-public-rtb" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "my-vpc-public-rtb"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.my-vpc-public-rtb.id
}
resource "aws_main_route_table_association" "set_main_rtb" {
  vpc_id         = aws_vpc.my-vpc.id
  route_table_id = aws_route_table.my-vpc-public-rtb.id
}

# sg
resource "aws_security_group" "allow_def" {
  name        = "my-vpc-public-sg"
  description = "Allow inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my-vpc.id
  tags = {
    Name = "my-vpc-public-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-tcp" {
  security_group_id = aws_security_group.allow_def.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  security_group_id = aws_security_group.allow_def.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_def.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
