resource "aws_route_table" "PublicRouteTable" {
  vpc_id = data.aws_vpc.GetVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.GetIGW.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation1" {
  subnet_id      = aws_subnet.PublicSubnet1.id
  route_table_id = aws_route_table.PublicRouteTable.id
}

resource "aws_route_table_association" "PublicSubnetRouteTableAssociation2" {
  subnet_id      = aws_subnet.PublicSubnet2.id
  route_table_id = aws_route_table.PublicRouteTable.id
}