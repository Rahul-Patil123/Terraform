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
    vpc_id = aws_subnet.dev_subnet_1.id
    cidr_block = "10.0.10.0/24"
    availabilty_zone = "ap-south-1a"
}