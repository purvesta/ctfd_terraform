#############
# Build VPC #
#############

resource "aws_vpc" "ctf-interface" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "${var.service}-vpc"
  }
}

resource "aws_internet_gateway" "ctf-interface-gw" {
  vpc_id = aws_vpc.ctf-interface.id

  tags = {
    Name = "${var.service}-inet-gw"
  }
}

resource "aws_subnet" "ctfd-subnet-1" {
  vpc_id     = aws_vpc.ctf-interface.id
  cidr_block = var.ctfd-subnet-1-cidr
  availability_zone = "${var.region}${var.az1}"

  tags = {
    Name = "${var.service}-subnet-1"
  }
}

resource "aws_subnet" "ctfd-subnet-2" {
  vpc_id     = aws_vpc.ctf-interface.id
  cidr_block = var.ctfd-subnet-2-cidr
  availability_zone = "${var.region}${var.az2}"

  tags = {
    Name = "${var.service}-subnet-2"
  }
}

# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.ctf-interface.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ctf-interface-gw.id
  }

  tags = {
    Name = "${var.service}-pub-rt"
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.ctfd-subnet-1.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.ctfd-subnet-2.id
}
