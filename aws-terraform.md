# AWS i Terraform - Scenariusze

## VPC (prywatna i publiczna podsieć)

#### terraform.tfvars

```
vpc_cidr = "10.0.0.0/16"
vpc_public_subnet = "10.0.1.0/24"
vpc_private_subnet = "10.0.2.0/24"
vpc_subnet_availability_zone = "eu-central-1b"
```

#### vpc.tf
```
variable "vpc_cidr" {}
variable "vpc_public_subnet" {}
variable "vpc_private_subnet" {}
variable "vpc_subnet_availability_zone" {}

# Create VPC and attach Internet Gateway
resource "aws_vpc" "Main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Main"
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id =  aws_vpc.Main.id
  tags = {
    Name = "Main"
  }
}

# Create a Public and Private Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id =  aws_vpc.Main.id
  cidr_block = "${var.vpc_public_subnet}"
  availability_zone= "${var.vpc_subnet_availability_zone}"
  map_public_ip_on_launch = true
  tags = {
    Name = "MainPublic"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id =  aws_vpc.Main.id
  cidr_block = "${var.vpc_private_subnet}"
  map_public_ip_on_launch = false
  availability_zone= "${var.vpc_subnet_availability_zone}"
  tags = {
    Name = "MainPrivate"
  }
}

# NAT and elastic IP
resource "aws_eip" "natIP" {
  vpc   = true
  tags = {
    Name = "FOR MAIN VPC NAT"
  }
}
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.natIP.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = "MainNAT"
  }
}

# Route table and association for Public Subnet
resource "aws_route_table" "PublicRT" {
  vpc_id =  aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "MainPublic"
  }
}
resource "aws_route_table_association" "PublicRTAssociation" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.PublicRT.id
}

# Route table and association for Private Subnet
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.Main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  }
  tags = {
    Name = "MainPrivate"
  }
}
resource "aws_route_table_association" "PrivateRTAssociation" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.PrivateRT.id
}

```
