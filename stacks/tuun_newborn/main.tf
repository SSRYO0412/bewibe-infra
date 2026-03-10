# =============================================================================
# TUUN Newborn Stack - Main Configuration
# =============================================================================
# TUUN Newborn アプリケーションのリソースを管理するスタック
# (TUUN の複製環境 - 独立して動作)
# - Cognito User Pool (新規作成)
# - DynamoDB テーブル (17個)
# - Lambda 関数 (29個)
# - API Gateway (8個)
# - S3 バケット (4つ)
# - IAM ロール・ポリシー (新規作成)
# - EventBridge スケジュール (2個)
# =============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.0"
    }
  }
}

# =============================================================================
# Local Values
# =============================================================================

locals {
  common_tags = {
    Project     = "tuun_newborn"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Stack       = "tuun_newborn"
  }

  # Lambda 関数名のプレフィックス
  lambda_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
