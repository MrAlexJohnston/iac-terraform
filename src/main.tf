data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
 cidr_block = "10.192.0.0/16"
 
 tags = {
   Name = "${var.name} - VPC"
 }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
 
 tags = {
   Name = "${var.name} - Public Subnet (AZ${count.index + 1})"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
 
 tags = {
   Name = "${var.name} - Private Subnet (AZ${count.index + 1})"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "${var.name} - Internet Gateway"
 }
}

resource "aws_route_table" "public_route_table" {
 vpc_id = aws_vpc.main.id
 
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.gw.id
 }
 
 tags = {
   Name = "${var.name} - Public Route Table"
 }
}

resource "aws_route_table_association" "public_subnet_association" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_route_table.id
}