# Create VPC
resource "aws_vpc" "vpc_1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_1"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "gw_igw"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "nat_eip"
  }
}

# Create NAT Gateway for Private Subnet Internet Access
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_1.id # Replace with the chosen subnet
}

# Create Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_2"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-1b"
  tags = {
    Name = "private_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-1c"
  tags = {
    Name = "private_2"
  }
}

# Create Security Group
resource "aws_security_group" "sg_1" {
  name   = "Access from internet to port 8080"
  vpc_id = aws_vpc.vpc_1.id
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_1"
  }
}

# Create Route Table for Public Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

# Create Route Table for Private Subnets
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_1.id
  tags = {
    Name = "private_rt"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

# Associate Route Table with Subnets
resource "aws_route_table_association" "subnet_association_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_association_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "subnet_associatioin_3" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "subnet_association_4" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt.id
}
