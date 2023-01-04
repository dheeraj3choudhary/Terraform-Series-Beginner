resource "aws_subnet" "PrivateSubnet" {
  vpc_id     = data.aws_vpc.GetVPC.id
  cidr_block = "10.0.128.0/18"
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = true

  tags = {
    Name = "PrivateSubnet"
  }
}