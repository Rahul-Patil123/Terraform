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