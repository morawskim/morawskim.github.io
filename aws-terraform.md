# AWS i Terraform - Scenariusze

## Budżet

#### terraform.tfvars

```
budget_notification_email = "email@example.com"
```

### budget.tf
```
variable "budget_notification_email" {}

resource "aws_budgets_budget" "budget" {
  name              = "budget-monthly"
  budget_type       = "COST"
  limit_amount      = "2"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.budget_notification_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 75
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_notification_email]
  }
}

```

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

## EC2 (bastion i app)

Do poprawnego działania wymaga także utworzenia podsieci prywatnej i publicznej.
Bastion jest tworzony w podsieci publicznej, instancje aplikacji w podsieci prywatnej.
Musimy zmodyfikować/ustawić wartość zmiennej lokalnej `vpc_id`.
Posiadając serwery w prywatnej sieci, możemy się do nich podłączyć poprzez protokół SSH wykorzystując bastion - `ssh -J ubuntu@bastion-ip ubuntu@app-private-ip`.
W konfiguracji ssh może to wyglądać następująco (wywołujemy `ssh remote-host-nickname`, aby połączyć się z serwerem dostępnym w podsieci prywatnej):


```
# Bastion
Host bastion-host-nickname
  HostName bastion-hostname
  # ...

# Serwer w prywatnej podsieci
Host remote-host-nickname
  HostName remote-hostname
  ProxyJump bastion-host-nickname
  # ...
```

#### terraform.tfvars

```
ec2_key_name = "marcin"
```

#### ec2.tf

```
variable "ec2_key_name" {}

locals {
  vpc_id = aws_vpc.Main.id
  ec2_key_name = var.ec2_key_name
  ec2_ami_id = data.aws_ami.ubuntu.id
  ec2_app_instance_type = "t2.micro"
  ec2_private_subnet = aws_subnet.private_subnet.id
  ec2_public_subnet = aws_subnet.public_subnet.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create security group and ec2
resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "SSH only"
  vpc_id = local.vpc_id

  # Allow SSH
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name ="bastion-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app" {
  name = "app"
  description = "SSH & HTTP"
  vpc_id = local.vpc_id

  # Allow SSH
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [aws_security_group.bastion.id]
  }

  # Allow Port 80
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name ="app-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "bastion" {
  ami = local.ec2_ami_id
  instance_type = "t2.micro"
  subnet_id = local.ec2_public_subnet
  key_name = local.ec2_key_name

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }

  tags = {
    Name ="Bastion"
    OS = "Ubuntu"
  }

  depends_on = [ aws_security_group.bastion ]
}

resource "aws_instance" "app" {
  count = 1
  ami = local.ec2_ami_id
  instance_type = local.ec2_app_instance_type
  subnet_id = local.ec2_private_subnet
  key_name = local.ec2_key_name

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }

  user_data = <<EOF
#!/bin/bash
apt-get -y update && apt-get -y install nginx
EOF

  tags = {
    Name ="App-${count.index}"
    OS = "Ubuntu"
  }

  depends_on = [ aws_security_group.app ]
}

```
