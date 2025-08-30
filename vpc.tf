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
variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availiblity_zones" "azs" {}

module "myapp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.64.0"
    name = "myapp-vpc"
    cidr = var.vpc_cidr_block
    # Best practice is one public and one private subnet in each availibility zone
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks
    azs = data.aws_availiblity_zones.azs.names

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostname = true

    tags {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    }

}