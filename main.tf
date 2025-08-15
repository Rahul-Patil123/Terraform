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
variable "cidr_block" {
  description = "Vpc id for default vpc"
  type = list(object({
    cidr_block = string
    name = string
  }))
}
#Terraform environment variable
variable avail_zone {}

resource "aws_subnet" "dev_subnet_2"{
    vpc_id = data.aws_vpc.existing_vpc.id
    cidr_block = var.cidr_block[0].cidr_block
    tags = {
        name = var.cidr_block[0].name
    }
    availabilty_zone = var.avail_zone
}

output "dev-vpc-id" {
  value = "data.aws_vpc.existing_vpc.id"
}
