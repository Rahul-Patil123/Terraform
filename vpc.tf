variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

module "myapp-vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.64.0"
    name = "myapp-vpc"
    cidr = var.vpc_cidr_block
    # Best practice is one public and one private subnet in each availibility zone
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks
}