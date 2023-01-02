# Author :- Dheeraj Choudhary

output "vpc_id" {
  value       = aws_vpc.CustomVPC.id
  description = "This is vpc id."
}

output "enable_dns_support" {
  value       = aws_vpc.CustomVPC.enable_dns_support
  description = "Check whether dns support is enabled for VPC."
}

output "enable_dns_hostnames" {
  value       = aws_vpc.CustomVPC.enable_dns_hostnames
  description = "Check whether dns hostname is enabled for VPC."
}

output "aws_internet_gateway_id" {
  value       = aws_internet_gateway.IGW.id
  description = "Internet gateway id."
}

output "igw_aws_account" {
  value       = aws_internet_gateway.IGW.owner_id
  description = "AWS Account id to which internet gateway is associated."
}