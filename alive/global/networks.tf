resource "aws_vpc" "vpc-west-primary" {
  provider             = aws.region-west-primary
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-west-1"
  }
}
resource "aws_vpc" "vpc-east-primary" {
  provider             = aws.region-east-primary
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-east-1"
  }
}

resource "aws_internet_gateway" "igw-west-1" {
  provider = aws.region-west-primary
  vpc_id   = aws_vpc.vpc-west-primary.id
}

resource "aws_internet_gateway" "igw-east-1" {
  provider = aws.region-east-primary
  vpc_id   = aws_vpc.vpc-east-primary.id
}

resource "aws_vpc_peering_connection" "uswest1-useast1" {
  provider    = aws.region-west-primary
  peer_vpc_id = aws_vpc.vpc-east-primary.id
  vpc_id      = aws_vpc.vpc-west-primary.id
  peer_region = var.region-east-primary
}

resource "aws_vpc_peering_connection_accepter" "accept-peering-east-1" {
  provider                  = aws.region-east-primary
  vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  auto_accept               = true
}

resource "aws_route_table" "internet-route-west" {
  provider = aws.region-west-primary
  vpc_id   = aws_vpc.vpc-west-primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-west-1.id
  }
  route {
    cidr_block                = "192.168.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "192.168.2.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "192.168.3.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "192.168.4.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "West-Primary-RT"
  }
}

resource "aws_main_route_table_association" "west-primary-rt-assoc" {
  provider       = aws.region-west-primary
  vpc_id         = aws_vpc.vpc-west-primary.id
  route_table_id = aws_route_table.internet-route-west.id
}

resource "aws_route_table" "internet-route-east" {
  provider = aws.region-east-primary
  vpc_id   = aws_vpc.vpc-east-primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-east-1.id
  }
  route {
    cidr_block                = "10.0.1.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "10.0.2.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "10.0.3.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  route {
    cidr_block                = "10.0.4.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.uswest1-useast1.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "East-Primary-RT"
  }
}

resource "aws_main_route_table_association" "east-primary-rt-assoc" {
  provider       = aws.region-east-primary
  vpc_id         = aws_vpc.vpc-east-primary.id
  route_table_id = aws_route_table.internet-route-east.id
}
