terraform {
    required_version = ">= 1.8.2"
}

locals {
  common_tags = {
    Name = "mlops_pipeline"
  }
}

# Create a VPC
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"

    tags = local.common_tags
}


# Create a Subnet
resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"

    tags = local.common_tags
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = local.common_tags
}

# Create a Security Group
resource "aws_security_group" "sg" {
    vpc_id = aws_vpc.vpc.id
    name = "instance_sg"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = local.common_tags
}

# Configure the VPC's default route table
resource "aws_default_route_table" "rtb" {
    default_route_table_id = aws_vpc.vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = local.common_tags
}

# Generate key pair
resource "tls_private_key" "generated_key" {
    algorithm = "RSA"
    rsa_bits = 4096
}

# Create a key pair
resource "aws_key_pair" "key" {
    key_name = var.key-pair-name
    public_key = tls_private_key.generated_key.public_key_openssh
}

# Create an EC2 instance
resource "aws_instance" "app" {
    ami = var.instance_ami.id
    instance_type = var.instance_type
    vpc_security_group_ids = [ aws_security_group.sg.id ]
    subnet_id = aws_subnet.subnet.id
    associate_public_ip_address = true
    key_name = aws_key_pair.key.key_name

    tags = local.common_tags
}

# Get private key locally
resource "local_sensitive_file" "private_key_file" {
    content = tls_private_key.generated_key.private_key_openssh
    filename = "${path.module}/../../../${aws_key_pair.key.key_name}.pem"
}

# Set Public IP for Ansible
resource "local_file" "set_ip_file" {
    content = "${var.instance_ami.user}@${aws_instance.app.public_ip}"
    filename  = "${path.module}/../../../ansible/etc/hosts"
}