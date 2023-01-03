resource "aws_subnet" "PublicSubnet1" {
  vpc_id     = data.aws_vpc.GetVPC.id
  cidr_block = "10.0.0.0/18"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet1"
    Type = "Public"
  }
}
resource "aws_subnet" "PublicSubnet2" {
  vpc_id     = data.aws_vpc.GetVPC.id
  cidr_block = "10.0.64.0/18"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet2"
    Type = "Public"
  }
}