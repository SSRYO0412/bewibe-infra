# =============================================================================
# IAM Module Outputs
# =============================================================================

output "role_name" {
  description = "IAM ロール名"
  value       = aws_iam_role.this.name
}

output "role_arn" {
  description = "IAM ロール ARN"
  value       = aws_iam_role.this.arn
}

output "role_id" {
  description = "IAM ロール ID"
  value       = aws_iam_role.this.id
}

output "policy_arn" {
  description = "カスタムポリシー ARN"
  value       = var.create_policy ? aws_iam_policy.this[0].arn : null
}
