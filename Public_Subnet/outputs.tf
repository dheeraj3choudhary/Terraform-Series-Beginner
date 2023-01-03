output "PublicSubnet1" {
  value       = aws_subnet.PublicSubnet1.id
  description = "This is first public subnet id."
}
output "PublicSubnet2" {
  value       = aws_subnet.PublicSubnet2.id
  description = "This is first second subnet id."
}

output "PublicRouteTable" {
  value       = aws_route_table.PublicRouteTable.id
  description = "Customu public route table id."
}