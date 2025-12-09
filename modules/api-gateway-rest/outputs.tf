# =============================================================================
# API Gateway REST Module Outputs
# =============================================================================

output "rest_api_id" {
  description = "REST API ID"
  value       = aws_api_gateway_rest_api.this.id
}

output "rest_api_arn" {
  description = "REST API ARN"
  value       = aws_api_gateway_rest_api.this.arn
}

output "root_resource_id" {
  description = "ルートリソース ID"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "execution_arn" {
  description = "実行 ARN"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "stage_invoke_url" {
  description = "ステージ呼び出し URL"
  value       = var.create_stage ? aws_api_gateway_stage.this[0].invoke_url : null
}
