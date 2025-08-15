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
    access_key = my_access_key
    secret_key = my_secret_key
}
resource "aws_vpc" "development" {
    cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "dev_subnet_1"{
    subnet_id = aws_subnet.dev_subnet_1.id
    cidr_block = "10.0.10.0/24"
    availabilty_zone = "ap-south-1a"
}
data "aws_vpc" "existing_vpc"{
    default = true
}
variable "default_cidr_block" {
  description = "Vpc id for default vpc"
  default = "10.0.10.0/24"
  type = string
}

resource "aws_subnet" "dev_subnet_2"{
    vpc_id = var.default_cidr_block
    cidr_block = "172.31.10.0/24"
    availabilty_zone = "ap-south-1a"
}
output "dev-vpc-id" {
  value = "data.aws_vpc.existing_vpc.id"
}
