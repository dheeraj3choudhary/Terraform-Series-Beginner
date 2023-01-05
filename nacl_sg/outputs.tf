output "NACL" {
  value       = aws_network_acl.aws_nacl.id
  description = "A reference to the created NACL"
}
output "SID" {
  value       = aws_security_group.ec2_sg.id
  description = "A reference to the created NACL Inbound Rule"
}