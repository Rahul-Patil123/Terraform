resource "aws_subnet" "myapp_subnet_1" {
    vpc_id = var.vpc_id
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
    default_route_table_id = var.default_route_table_id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myapp-igw.id
    }
    tags = {
        Name: "${var.env_prefix}-rtb"
    }
}
resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = var.vpc_id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}