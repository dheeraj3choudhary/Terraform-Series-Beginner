output "user_arn" {
  value = aws_iam_user.userlist.*.arn
}
output "dev-group-id" {
  value       = aws_iam_group.dev_group.id
  description = "A reference to the created IAM group"
}
