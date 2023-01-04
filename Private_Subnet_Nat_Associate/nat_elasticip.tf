resource "aws_eip" "CustomEIP" {
  vpc      = true
  tags = {
    "Name" = "CustomEIP"
  }
}
resource "aws_nat_gateway" "CustomNAT" {
  allocation_id = aws_eip.CustomEIP.id
  subnet_id     = data.aws_subnet.GetPublicSubnet.id
  tags = {
    Name = "CustomNAT"
  }
}