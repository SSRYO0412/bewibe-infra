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

# =============================================================================
# Cognito Outputs
# =============================================================================

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_arn" {
  description = "Cognito User Pool ARN"
  value       = module.cognito.user_pool_arn
}

output "cognito_app_client_id" {
  description = "Cognito App Client ID"
  value       = module.cognito.app_client_id
}

# =============================================================================
# S3 Outputs
# =============================================================================

output "s3_gene_data_bucket" {
  description = "遺伝子データ用 S3 バケット名"
  value       = aws_s3_bucket.gene_data.id
}

output "s3_certificates_bucket" {
  description = "証明書用 S3 バケット名"
  value       = aws_s3_bucket.certificates.id
}

output "s3_temp_transfer_bucket" {
  description = "一時データ移行用 S3 バケット名"
  value       = aws_s3_bucket.gene_data_transfer.id
}

# =============================================================================
# DynamoDB Outputs
# =============================================================================

output "dynamodb_users_table" {
  description = "Users テーブル名"
  value       = aws_dynamodb_table.users.name
}

output "dynamodb_blood_results_table" {
  description = "blood-results テーブル名"
  value       = aws_dynamodb_table.blood_results.name
}

output "dynamodb_gene_analysis_results_table" {
  description = "gene-analysis-results テーブル名"
  value       = aws_dynamodb_table.gene_analysis_results.name
}

# =============================================================================
# Lambda Outputs
# =============================================================================

output "lambda_create_user_arn" {
  description = "CreateUserFunctionPython-newborn ARN"
  value       = aws_lambda_function.create_user.arn
}

output "lambda_chat_api_arn" {
  description = "chat-api-function-newborn ARN"
  value       = aws_lambda_function.chat_api.arn
}

# =============================================================================
# API Gateway Outputs
# =============================================================================

output "api_user_id" {
  description = "UserAPI-newborn REST API ID"
  value       = aws_api_gateway_rest_api.user_api.id
}

output "api_chat_id" {
  description = "TUUNapp-Chat-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.chat_api.id
}

output "api_health_profile_id" {
  description = "TUUNapp-Health-Profile-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.health_profile_api.id
}

output "api_gene_id" {
  description = "TUUNapp-Get-Gene-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.get_gene_api.id
}

output "api_blood_id" {
  description = "TUUNapp-Get-Blood-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.get_blood_api.id
}

output "api_gene_transfer_id" {
  description = "TUUNapp-Gene-Transfer-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.gene_transfer_api.id
}

output "api_intelligence_id" {
  description = "TUUNapp-Intelligence-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.intelligence_api.id
}

# =============================================================================
# Additional Lambda Outputs
# =============================================================================

output "lambda_intelligence_api_arn" {
  description = "intelligence-api-function-newborn ARN"
  value       = aws_lambda_function.intelligence_api.arn
}

output "lambda_intelligence_api_claude_arn" {
  description = "intelligence-api-claude-newborn ARN"
  value       = aws_lambda_function.intelligence_api_claude.arn
}

# =============================================================================
# Additional DynamoDB Outputs
# =============================================================================

output "dynamodb_device_tokens_table" {
  description = "tuun-device-tokens-newborn テーブル名"
  value       = aws_dynamodb_table.device_tokens.name
}

output "dynamodb_rate_limits_table" {
  description = "tuun-rate-limits-newborn テーブル名"
  value       = aws_dynamodb_table.rate_limits.name
}

output "dynamodb_eval_results_table" {
  description = "tuun-eval-results-newborn テーブル名"
  value       = aws_dynamodb_table.eval_results.name
}

# =============================================================================
# Agent Architecture v8 Outputs
# =============================================================================

# DynamoDB テーブル名

output "dynamodb_agent_memories_table" {
  description = "tuun-agent-memories-newborn テーブル名"
  value       = aws_dynamodb_table.agent_memories.name
}

output "dynamodb_agent_profiles_table" {
  description = "tuun-agent-profiles-newborn テーブル名"
  value       = aws_dynamodb_table.agent_profiles.name
}

output "dynamodb_agent_chat_events_table" {
  description = "tuun-agent-chat-events-newborn テーブル名"
  value       = aws_dynamodb_table.agent_chat_events.name
}

output "dynamodb_agent_usage_table" {
  description = "tuun-agent-usage-newborn テーブル名"
  value       = aws_dynamodb_table.agent_usage.name
}

output "dynamodb_agent_device_sync_table" {
  description = "tuun-agent-device-sync-newborn テーブル名"
  value       = aws_dynamodb_table.agent_device_sync.name
}

output "dynamodb_agent_chat_history_table" {
  description = "tuun-agent-chat-history-newborn テーブル名"
  value       = aws_dynamodb_table.agent_chat_history.name
}

output "dynamodb_subscriptions_table" {
  description = "tuun-subscriptions-newborn テーブル名"
  value       = aws_dynamodb_table.subscriptions.name
}

output "dynamodb_agent_scheduled_jobs_table" {
  description = "tuun-agent-scheduled-jobs-newborn テーブル名"
  value       = aws_dynamodb_table.agent_scheduled_jobs.name
}

# Lambda ARN

output "lambda_agent_chat_processor_arn" {
  description = "agent-chat-processor-newborn ARN"
  value       = aws_lambda_function.agent_chat_processor.arn
}

output "lambda_scheduled_executor_arn" {
  description = "scheduled-executor-newborn ARN"
  value       = aws_lambda_function.scheduled_executor.arn
}

# API Gateway

output "api_agent_id" {
  description = "TUUNapp-Agent-API-newborn REST API ID"
  value       = aws_api_gateway_rest_api.agent_api.id
}

output "api_agent_invoke_url" {
  description = "Agent API prod stage invoke URL"
  value       = aws_api_gateway_stage.agent_api_prod.invoke_url
}

# S3

output "s3_config_bucket" {
  description = "エージェント設定用 S3 バケット名"
  value       = aws_s3_bucket.config.id
}
