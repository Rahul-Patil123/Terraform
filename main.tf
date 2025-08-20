terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws"{
    region = "ap-south-1"
}

variable avail_zone {}
variable vpc_cidr_block {}
variable subnet_cidr_block {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
variable my_public_key_location {}

resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name: "${var.env_prefix}-vpc"
    }
}
resource "aws_subnet" "myapp_subnet_1" {
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# resource "aws_route_table" "myapp-route-table" {
#     vpc_id = aws_vpc.myapp-vpc.id
#     route{
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.myapp-igw.id
#     }
#     tags = {
#         Name: "${var.env_prefix}-rtb"
#     }
# }
# resource "aws_route_table_associations" "a-rtb" {
#     subnet_id = aws_subnet.myapp_subnet_1.id
#     route_table_id = aws_route_table.myapp-route-table.id
# }

# data "aws_vpc" "existing_vpc"{
#     default = true
# }
# output "dev-vpc-id" {
#   value = "data.aws_vpc.existing_vpc.id"
# }
resource "aws_default_route_table" "main-rtb" {
    default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}
resource "aws_default_security_group" "default-sg" {
    vpc_id = aws_vpc.myapp-vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    engress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }
    tags = {
        Name: "${var.env_prefix}-default-sg"
    }
}
data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amazon"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}
resource "aws_key_pair" "ssh-key" {
    key_name = "server-key-pair"
    public_key = file(var.my_public_key_location)
}

resource "aws_instance" "myapp-server" {
    # ami = "ami-0b83c7f5e2823d1f4"
    ami = data.aws_ami.latest-amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.myapp_subnet_1.id
    vpc_security_group_ids = [aws_default_security_group.default-sg.id]

    associate_public_ip_address = true
    key_name = "server-key-pair"
    tags = {
        Name: "${var.env_prefix}-server"
    }
}