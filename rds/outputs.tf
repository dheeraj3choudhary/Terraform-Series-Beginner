output "aws_db_subnet_group" {
  value       = aws_db_subnet_group.rds_db_subnet_group.id
  description = "This is DB Subnet Group id."
}
output "aws_db_instance" {
  value       = aws_db_instance.rds_instance.id
  description = "This is RDS instance ID."
}
output "aws_db_parameter_group" {
  value       = aws_db_parameter_group.rds_para_grp.id
  description = "This is RDS parameter group ID."
}