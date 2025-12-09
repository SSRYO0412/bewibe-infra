# =============================================================================
# Outputs
# =============================================================================

output "aws_account_id" {
  description = "AWS アカウント ID"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS リージョン"
  value       = data.aws_region.current.name
}

# TODO: Phase 5 で CloudTrail 関連の output を追加
# output "cloudtrail_arn" {
#   description = "CloudTrail ARN"
#   value       = module.cloudtrail.trail_arn
# }

# TODO: Phase 3 で Parameter Store / Secrets Manager 関連の output を追加
