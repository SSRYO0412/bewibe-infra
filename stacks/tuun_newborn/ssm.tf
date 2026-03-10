# =============================================================================
# SSM Parameter Store
# =============================================================================
# TUUN Newborn アプリケーションの設定値（非秘密）を一元管理
#
# 原則: 秘密情報は SSM ではなく Secrets Manager に保存
#
# 注意: API Gateway エンドポイントと Cognito 値は terraform apply 後に
# 実際の値で更新する必要があります。初回は PENDING 値で作成。
# =============================================================================

# -----------------------------------------------------------------------------
# Cognito 設定
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "cognito_user_pool_id" {
  name        = "/tuun_newborn/cognito/user-pool-id"
  type        = "String"
  value       = module.cognito.user_pool_id
  description = "Cognito User Pool ID for TUUN Newborn app"
}

resource "aws_ssm_parameter" "cognito_client_id" {
  name        = "/tuun_newborn/cognito/client-id"
  type        = "String"
  value       = module.cognito.app_client_id
  description = "Cognito App Client ID for TUUN Newborn app"
}

# -----------------------------------------------------------------------------
# API Gateway エンドポイント
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "api_user" {
  name        = "/tuun_newborn/api/user/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "UserAPI endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_chat" {
  name        = "/tuun_newborn/api/chat/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Chat API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_health_profile" {
  name        = "/tuun_newborn/api/health-profile/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Health Profile API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_gene" {
  name        = "/tuun_newborn/api/gene/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Gene Data API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_blood" {
  name        = "/tuun_newborn/api/blood/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Blood Data API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "api_gene_transfer" {
  name        = "/tuun_newborn/api/gene-transfer/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Gene Transfer API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

# -----------------------------------------------------------------------------
# 環境設定
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "api_intelligence" {
  name        = "/tuun_newborn/api/intelligence/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Intelligence API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}

# -----------------------------------------------------------------------------
# 環境設定
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "environment" {
  name        = "/tuun_newborn/env"
  type        = "String"
  value       = "prod"
  description = "Environment name"
}

# -----------------------------------------------------------------------------
# Agent API エンドポイント (Agent Architecture v8)
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "api_agent" {
  name        = "/tuun_newborn/api/agent/endpoint"
  type        = "String"
  value       = "PENDING"
  description = "Agent API endpoint (newborn)"

  lifecycle {
    ignore_changes = [value]
  }
}
