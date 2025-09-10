# modules/network/main.tf - Módulo de Network

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  
  tags = {
    Name = "vpc-main"
  }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = "igw-main"
  }
}

# PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.key
  cidr_block              = each.value
  map_public_ip_on_launch = true
  
  tags = {
    Name = "subnet-public-${each.key}"
  }
}

# ROUTE TABLE FOR PUBLIC SUBNETS
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "rt-public"
  }
}

# ROUTE TABLE ASSOCIATIONS
resource "aws_route_table_association" "rt_public_associations" {
  for_each = aws_subnet.public_subnets
  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.rt_public.id
}

# SECURITY GROUP
resource "aws_security_group" "vpc_sg_public" {
  name        = "vpc-sg-public"
  description = "Security group for public resources with controlled access"
  vpc_id      = aws_vpc.vpc.id
  
  tags = {
    Name = "sg-public"
  }
}

# SECURITY GROUP RULES
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg_public.id
}

resource "aws_security_group_rule" "ingress_vpc" {
  type              = "ingress"
  description       = "Allow internal VPC communication"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.vpc_sg_public.id
}

resource "aws_security_group_rule" "ingress_ssh" {
  count             = var.allowed_ssh_cidr != "" ? 1 : 0
  type              = "ingress"
  description       = "Allow SSH access from specific IP"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allowed_ssh_cidr]
  security_group_id = aws_security_group.vpc_sg_public.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  description       = "Allow HTTP access from internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpc_sg_public.id
}