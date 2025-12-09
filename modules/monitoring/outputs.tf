# =============================================================================
# Monitoring Module Outputs
# =============================================================================

output "cloudtrail_arn" {
  description = "CloudTrail ARN"
  value       = var.create_cloudtrail ? aws_cloudtrail.this[0].arn : null
}

output "cloudtrail_id" {
  description = "CloudTrail ID"
  value       = var.create_cloudtrail ? aws_cloudtrail.this[0].id : null
}

output "cloudtrail_s3_bucket_id" {
  description = "CloudTrail ログ用 S3 バケット ID"
  value       = var.create_cloudtrail ? aws_s3_bucket.cloudtrail_logs[0].id : null
}

output "cloudtrail_s3_bucket_arn" {
  description = "CloudTrail ログ用 S3 バケット ARN"
  value       = var.create_cloudtrail ? aws_s3_bucket.cloudtrail_logs[0].arn : null
}

output "config_recorder_id" {
  description = "AWS Config Recorder ID"
  value       = var.create_aws_config ? aws_config_configuration_recorder.this[0].id : null
}
