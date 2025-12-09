# =============================================================================
# SSM Parameter Store
# =============================================================================
# TUUN アプリケーションの設定値（非秘密）を一元管理
#
# 原則: 秘密情報は SSM ではなく Secrets Manager に保存
# =============================================================================

# -----------------------------------------------------------------------------
# Cognito 設定
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name        = "/tuun/cognito/user-pool-id"
  type        = "String"
  value       = "ap-northeast-1_cwAKljjzb"
  description = "Cognito User Pool ID for TUUN app"
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name        = "/tuun/cognito/client-id"
  type        = "String"
  value       = "3uhtrfkr51ggh4gi5s597klinf"
  description = "Cognito App Client ID for TUUN app"
}

# -----------------------------------------------------------------------------
# API Gateway エンドポイント
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "api_user" {
  name        = "/tuun/api/user/endpoint"
  type        = "String"
  value       = "https://02fc5gnwoi.execute-api.ap-northeast-1.amazonaws.com/dev"
  description = "UserAPI endpoint"
}

resource "aws_ssm_parameter" "api_chat" {
  name        = "/tuun/api/chat/endpoint"
  type        = "String"
  value       = "https://kbodeqy5wa.execute-api.ap-northeast-1.amazonaws.com/prod"
  description = "Chat API endpoint"
}

resource "aws_ssm_parameter" "api_health_profile" {
  name        = "/tuun/api/health-profile/endpoint"
  type        = "String"
  value       = "https://70ubpe7e14.execute-api.ap-northeast-1.amazonaws.com/prod"
  description = "Health Profile API endpoint"
}

resource "aws_ssm_parameter" "api_gene" {
  name        = "/tuun/api/gene/endpoint"
  type        = "String"
  value       = "https://kxuyul35l4.execute-api.ap-northeast-1.amazonaws.com/prod"
  description = "Gene Data API endpoint"
}

resource "aws_ssm_parameter" "api_blood" {
  name        = "/tuun/api/blood/endpoint"
  type        = "String"
  value       = "https://7rk2qibxm6.execute-api.ap-northeast-1.amazonaws.com/prod"
  description = "Blood Data API endpoint"
}

resource "aws_ssm_parameter" "api_gene_transfer" {
  name        = "/tuun/api/gene-transfer/endpoint"
  type        = "String"
  value       = "https://1ac2k99n71.execute-api.ap-northeast-1.amazonaws.com/prod"
  description = "Gene Transfer API endpoint"
}

# -----------------------------------------------------------------------------
# 環境設定
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "environment" {
  name        = "/tuun/env"
  type        = "String"
  value       = "prod"
  description = "Environment name"
}
