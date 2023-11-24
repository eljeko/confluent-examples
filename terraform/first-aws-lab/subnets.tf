variable "subnets_mappings" {
    default = {
        "az1" = {
            "subnet" = 1,
            "az" = "1"
        },
        "az2" = {
            "subnet" = 2,
            "az" = "2"
        },
        "az3" = {
            "subnet" = 3,
            "az" = "2"
        }
    }
  
}

resource "aws_subnet" "lab" {
  for_each = var.subnets_mappings

  vpc_id = aws_vpc.lab.id

  map_public_ip_on_launch = true

  cidr_block = "10.0.${each.value.subnet}.0/24"

  availability_zone_id = "eus1-${each.key}"


  tags = {
    Name = "${var.owner}-Managed-az${each.value.subnet}"
  }

}