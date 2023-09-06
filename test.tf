data "aws_ssm_parameter" "account_ids" {
  name = ""
}

locals {
  account_ids_raw = split(",", data.aws_ssm_parameter.account_ids.value)
  account_ids     = [for id in local.account_ids_raw : id != "" ? id : null]
}

locals {
  arns = [for id in local.account_ids : id != null ? "arn:aws:iam::${id}:role/*" : null]
}

variable "account_ids" {
  type    = list(string)
  default = []
}

resource "aws_ssm_parameter" "account_ids" {
  name  = "/my-namespace/account-ids"
  type  = "String"
  value = join(",", var.account_ids)
}

resource "aws_iam_policy" "example" {
  name        = "example-policy"
  description = "Example policy"

  dynamic "Statement" {
    for_each = local.include_iam_statements ? [for idx, arn in local.arns : arn != null ? idx : null] : []
    content {
      sid       = "statement-${Statement.key}"
      Effect    = "Allow"
      Action    = "sts:*"
      Resource  = [local.include_iam_statements ? local.arns[Statement.key] : null]
    }
  }
