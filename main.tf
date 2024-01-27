# Specify the AWS provider and region
provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16" # Change this to your desired CIDR block
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create a public subnet in the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24" # Change this to your desired CIDR block for the public subnet
  availability_zone       = "us-east-1a"  # Change this to your desired availability zone

  map_public_ip_on_launch = true
}

# Create a private subnet in the VPC
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24" # Change this to your desired CIDR block for the private subnet
  availability_zone       = "us-east-1b"  # Change this to your desired availability zone
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach the internet gateway to the public subnet
resource "aws_route" "route_to_igw" {
  route_table_id         = aws_subnet.public_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Create a security group for the EC2 instances
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
  # Define your security group rules here as needed
}

# Create a public EC2 instance in the public subnet
resource "aws_instance" "public_instance" {
  ami                    = "ami-0c55b159cbfafe1f0" # Change this to your desired AMI
  instance_type          = "t2.micro"             # Change this to your desired instance type
  subnet_id              = aws_subnet.public_subnet.id
  security_group_ids     = [aws_security_group.my_sg.id]
  key_name               = "your-key-pair"         # Change this to your key pair name

  # Additional instance configuration as needed
}

# Create a private EC2 instance in the private subnet
resource "aws_instance" "private_instance" {
  ami                    = "ami-0c55b159cbfafe1f0" # Change this to your desired AMI
  instance_type          = "t2.micro"             # Change this to your desired instance type
  subnet_id              = aws_subnet.private_subnet.id
  security_group_ids     = [aws_security_group.my_sg.id]
  key_name               = "your-key-pair"         # Change this to your key pair name

  # Additional instance configuration as needed
}

# Create a NAT gateway in the public subnet
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_instance.public_instance.network_interface_ids[0]

  subnet_id     = aws_subnet.public_subnet.id

  # Optionally, you can associate an Elastic IP with the NAT gateway
  # Uncomment the following line and provide an Elastic IP ID
  # elastic_ip    = "your-elastic-ip-id"
}

# Create a route in the private subnet's route table to route traffic through the NAT gateway
resource "aws_route" "route_to_nat_gateway" {
  route_table_id         = aws_subnet.private_subnet.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}
