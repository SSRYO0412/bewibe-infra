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

# TODO: Phase 2-6 (Cognito import 後) で有効化
# output "cognito_user_pool_id" {
#   description = "Cognito User Pool ID"
#   value       = aws_cognito_user_pool.main.id
# }

# =============================================================================
# S3 Outputs
# =============================================================================

# TODO: Phase 2-1 (S3 import 後) で有効化
# output "s3_gene_data_bucket" {
#   description = "遺伝子データ用 S3 バケット名"
#   value       = aws_s3_bucket.gene_data.id
# }

# =============================================================================
# DynamoDB Outputs
# =============================================================================

# TODO: Phase 2-2 (DynamoDB import 後) で有効化
# output "dynamodb_users_table" {
#   description = "Users テーブル名"
#   value       = aws_dynamodb_table.users.name
# }

# =============================================================================
# Lambda Outputs
# =============================================================================

# TODO: Phase 2-4 (Lambda import 後) で有効化
# output "lambda_create_user_arn" {
#   description = "CreateUserFunctionPython ARN"
#   value       = aws_lambda_function.create_user.arn
# }

# =============================================================================
# API Gateway Outputs
# =============================================================================

# TODO: Phase 2-5 (API Gateway import 後) で有効化
# output "api_user_endpoint" {
#   description = "UserAPI エンドポイント"
#   value       = aws_api_gateway_stage.user_api_prod.invoke_url
# }
