resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = data.aws_vpc.GetVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.CustomNAT.id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}
resource "aws_route_table_association" "PrivateSubnetRouteTableAssociation" {
  subnet_id      = aws_subnet.PrivateSubnet.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}