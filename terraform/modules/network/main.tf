variable "environment" {}
variable "aws_account" {}
variable "aws_region"  {}
variable "cidr_block"  { default = "10.0.0.0/16" }
variable "zone_a_cidr" { default = "10.0.1.0/24" }
variable "zone_b_cidr" { default = "10.0.2.0/24" }
variable "zone_c_cidr" { default = "10.0.3.0/24" }

resource "aws_vpc" "default" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "repairs-api-vpc-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "repairs-api-default-gw-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_route" "internet_access" {
  route_table_id = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.default.id
}

resource "aws_subnet" "zone_a" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.zone_a_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "repairs-api-subnet-${var.aws_region}a-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "zone_b" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.zone_b_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "repairs-api-subnet-${var.aws_region}b-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_subnet" "zone_c" {
  vpc_id = aws_vpc.default.id
  cidr_block = var.zone_c_cidr
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "repairs-api-subnet-${var.aws_region}c-${var.environment}"
    Environment = var.environment
  }
}

/*====
VPC's Default Security Group
======*/
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.default.id
  depends_on  = [aws_vpc.default]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = var.environment
  }
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "cidr_block" {
  value = aws_vpc.default.cidr_block
}

output "subnet_a" {
  value = aws_subnet.zone_a.id
}

output "subnet_b" {
  value = aws_subnet.zone_b.id
}

output "subnet_c" {
  value = aws_subnet.zone_c.id
}
