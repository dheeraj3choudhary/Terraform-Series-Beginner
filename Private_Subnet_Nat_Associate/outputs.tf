output "PrivateSubnet" {
  value       = aws_subnet.PrivateSubnet.id
  description = "This is private subnet id."
}
output "CustomEIP" {
  value       = aws_eip.CustomEIP.id
  description = "Custom elastic ip we created."
}
output "CustomNAT" {
  value       = aws_nat_gateway.CustomNAT.id
  description = "NAT Gateway ID."
}
output "PrivateRouteTable" {
  value       = aws_route_table.PrivateRouteTable.id
  description = "List custom privateroute table id."
}