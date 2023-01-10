output "CustomTG" {
  value       = aws_lb_target_group.CustomTG.id
  description = "This is Target Group id."
}
output "CustomELB" {
  value       = aws_lb.CustomELB.id
  description = "This is load balancer ID."
}
output "elb_sg" {
  value       = aws_security_group.elb_sg.id
  description = "This is Security Group ID."
}