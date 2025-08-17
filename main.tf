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
resource "aws_subnet" "myapp_subnet_1"{
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_block
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}


# data "aws_vpc" "existing_vpc"{
#     default = true
# }
# output "dev-vpc-id" {
#   value = "data.aws_vpc.existing_vpc.id"
# }