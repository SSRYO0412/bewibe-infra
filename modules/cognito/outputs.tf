# =============================================================================
# Cognito Module Outputs
# =============================================================================

output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.this.id
}

output "user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = aws_cognito_user_pool.this.arn
}

output "user_pool_endpoint" {
  description = "Cognito User Pool エンドポイント"
  value       = aws_cognito_user_pool.this.endpoint
}

output "app_client_id" {
  description = "App Client ID"
  value       = var.create_app_client ? aws_cognito_user_pool_client.this[0].id : null
}

output "app_client_secret" {
  description = "App Client Secret"
  value       = var.create_app_client && var.generate_client_secret ? aws_cognito_user_pool_client.this[0].client_secret : null
  sensitive   = true
}
