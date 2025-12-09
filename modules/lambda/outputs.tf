# =============================================================================
# Lambda Module Outputs
# =============================================================================

output "function_name" {
  description = "Lambda 関数名"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Lambda 関数 ARN"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Lambda 呼び出し ARN"
  value       = aws_lambda_function.this.invoke_arn
}

output "qualified_arn" {
  description = "Lambda Qualified ARN"
  value       = aws_lambda_function.this.qualified_arn
}

output "log_group_name" {
  description = "CloudWatch Log Group 名"
  value       = var.create_log_group ? aws_cloudwatch_log_group.this[0].name : null
}
