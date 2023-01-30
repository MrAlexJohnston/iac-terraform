resource "aws_vpc" "main" {
 cidr_block = "10.192.0.0/16"
 
 tags = {
   Name = "Test VPC"
 }
}