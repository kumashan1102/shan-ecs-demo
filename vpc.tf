locals {
  public_subnets = {
    "${var.region}a" = "10.1.0.0/24"
    "${var.region}b" = "10.1.1.0/24"
    "${var.region}c" = "10.1.2.0/24"
  }
  private_subnets = {
    "${var.region}a" = "10.1.10.0/24"
    "${var.region}b" = "10.1.11.0/24"
    "${var.region}c" = "10.1.12.0/24"
  }
}

resource "aws_vpc" "shan-ecs-demo" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "shan-ecs-demo-vpc"
  }
}

resource "aws_subnet" "shan-ecs-public" {
  count             = length(local.public_subnets)
  cidr_block        = element(values(local.public_subnets), count.index)
  vpc_id            = aws_vpc.shan-ecs-demo.id
  availability_zone = element(keys(local.public_subnets), count.index)
  tags = {
    Name = "shan-ecs-public"
  }
}


resource "aws_subnet" "shan-ecs-private" {
  #cidr_block = "10.1.2.0/24"
  count             = length(local.private_subnets)
  cidr_block        = element(values(local.private_subnets), count.index)
  vpc_id            = aws_vpc.shan-ecs-demo.id
  availability_zone = element(keys(local.private_subnets), count.index)
  tags = {
    Name = "shan-ecs-private"
  }
}


resource "aws_internet_gateway" "shan-ecs-igw" {
  vpc_id = aws_vpc.shan-ecs-demo.id

  tags = {
    Name = "shan-ecs-igw"
  }
}

resource "aws_route_table" "shan-ecs-route-table-public" {
  vpc_id = aws_vpc.shan-ecs-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shan-ecs-igw.id
  }
  route {
    cidr_block = var.VPC_CIDR
    gateway_id = "local"
  }
  timeouts {
    create = "10m"
  }
}

resource "aws_route_table" "shan-ecs-route-table-private" {
  vpc_id = aws_vpc.shan-ecs-demo.id
  route {
    cidr_block = var.VPC_CIDR
    gateway_id = "local"
  }
  timeouts {
    create = "10m"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.shan-ecs-private.*.id, count.index)
  route_table_id = aws_route_table.shan-ecs-route-table-private.id
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.shan-ecs-public.*.id, count.index)
  route_table_id = aws_route_table.shan-ecs-route-table-public.id
}