# Query all AWS Availability Zone
data "aws_availability_zones" "available" {}

# VPC Creation
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.org}-${var.env}-vpc"
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.org}-${var.env}-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.org}-${var.env}-public-rt"
  }
}

# Private Route Table
resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  tags = {
    Name = "${var.org}-${var.env}-private-rt"
  }
}

resource "aws_route" "ngw" {
  route_table_id         = aws_default_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidrs)
  cidr_block              = var.public_cidrs[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                     = "${var.org}-${var.env}-public-subnet.${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidrs)
  cidr_block        = var.private_cidrs[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                                                       = "${var.org}-${var.env}-private-subnet.${count.index + 1}"
    "kubernetes.io/cluster/${var.env}-${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                          = "1"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = length(var.public_cidrs)
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  depends_on     = [aws_route_table.public_route, aws_subnet.public_subnet]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = length(var.private_cidrs)
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  depends_on     = [aws_default_route_table.private_route, aws_subnet.private_subnet]
}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    Name = "${var.org}-${var.env}-ngw-eip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.0.id
  tags = {
    Name = "${var.org}-${var.env}-nat-gw"
  }
}

resource "aws_route" "public_route_to_igw" {
  depends_on             = [aws_route_table.public_route]
  route_table_id         = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}