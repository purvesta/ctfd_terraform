#############
# Build VPC #
#############

resource "aws_vpc" "minecloud" {
  cidr_block       = var.vpc-cidr
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "minecloud"
  }
}

resource "aws_internet_gateway" "minecloud-gw" {
  vpc_id = aws_vpc.minecloud.id

  tags = {
    Name = "minecloud"
  }
}

resource "aws_subnet" "minecloud-frontend" {
  vpc_id     = aws_vpc.minecloud.id
  cidr_block = var.vpc-minecloud-frontend-subnet-cidr
  availability_zone = "${var.region}a"

  tags = {
    Name = "minecloud"
  }
}

resource "aws_subnet" "minecloud-frontend2" {
  vpc_id     = aws_vpc.minecloud.id
  cidr_block = var.vpc-minecloud-frontend2-subnet-cidr
  availability_zone = "${var.region}b"

  tags = {
    Name = "minecloud"
  }
}

# Route tables for the subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.minecloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecloud-gw.id
  }

  tags = {
    Name = "minecloud"
  }
}

resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.minecloud-frontend.id
}

resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.minecloud-frontend2.id
}
