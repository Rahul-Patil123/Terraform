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

resource "aws_route_table" "myapp-route-table" {
    vpc_id = aws_vpc.myapp-vpc.id
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
resource "aws_route_table_associations" "a-rtb" {
    subnet_id = aws_subnet.myapp_subnet_1.id
    route_table_id = aws_route_table.myapp-route-table.id
}
# data "aws_vpc" "existing_vpc"{
#     default = true
# }
# output "dev-vpc-id" {
#   value = "data.aws_vpc.existing_vpc.id"
# }