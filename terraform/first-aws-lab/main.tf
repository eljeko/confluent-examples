resource "aws_vpc" "lab" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.owner}-Managed"
  }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "${var.owner}-Managed"
  }
}

resource "aws_route" "lab_default_route" {
    route_table_id = aws_vpc.lab.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id    
}

