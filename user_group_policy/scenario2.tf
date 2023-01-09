resource "aws_iam_policy" "dev_group_policy" {
  name        = "dev-policy"
  description = "My test policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group_policy_attachment" "custom_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = aws_iam_policy.dev_group_policy.arn
}