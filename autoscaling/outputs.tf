output "asg_sg" {
  value       = aws_security_group.asg_sg.id
  description = "This is Security Group for autoscaling launch configuration."
}
output "aws_launch_configuration" {
  value       = aws_launch_configuration.launch_config_dev.id
  description = "This is ASG Launch Configuration ID."
}
output "autoscaling_group_dev" {
  value       = aws_autoscaling_group.autoscaling_group_dev.id
  description = "This is ASG ID."
}