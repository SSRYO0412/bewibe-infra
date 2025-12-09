# =============================================================================
# IAM Module
# =============================================================================
# IAM ロール・ポリシーを作成する再利用可能モジュール
# =============================================================================

resource "aws_iam_role" "this" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.trusted_services
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "this" {
  count = var.create_policy ? 1 : 0

  name        = var.policy_name
  description = var.policy_description

  policy = var.policy_document
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = var.create_policy ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
