#############
# Build VPC #
#############

resource "aws_vpc" "challenges" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = var.service
  }
}

resource "aws_internet_gateway" "challenges-gw" {
  vpc_id = aws_vpc.challenges.id

  tags = {
    Name = var.service
  }
}

resource "aws_subnet" "challenge-subnet-1" {
  vpc_id     = aws_vpc.challenges.id
  cidr_block = var.vpc-challenge-subnet-1-cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = var.service
  }
}

resource "aws_subnet" "challenge-subnet-2" {
  vpc_id     = aws_vpc.challenges.id
  cidr_block = var.vpc-challenge-subnet-2-cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = var.service
  }
}

# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.challenges.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.challenges-gw.id
  }

  tags = {
    Name = var.service
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.challenge-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.challenge-subnet-2.id
}
