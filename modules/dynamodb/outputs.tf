# =============================================================================
# DynamoDB Module Outputs
# =============================================================================

output "table_name" {
  description = "DynamoDB テーブル名"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDB テーブル ARN"
  value       = aws_dynamodb_table.this.arn
}

output "table_id" {
  description = "DynamoDB テーブル ID"
  value       = aws_dynamodb_table.this.id
}
