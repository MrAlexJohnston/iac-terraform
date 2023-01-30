data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
 cidr_block = "10.192.0.0/16"
 
 tags = {
   Name = "Test VPC"
 }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
 
 tags = {
   Name = "Public Subnet (AZ${count.index + 1})"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 availability_zone = data.aws_availability_zones.available.names[count.index]
 
 tags = {
   Name = "Private Subnet (AZ${count.index + 1})"
 }
}