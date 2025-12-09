# =============================================================================
# TUUN Stack - Main Configuration
# =============================================================================
# TUUN アプリケーションのリソースを管理するスタック
# - Cognito User Pool
# - DynamoDB テーブル (7つ)
# - Lambda 関数 (11個)
# - API Gateway (6つ)
# - S3 バケット (3つ)
# - IAM ロール・ポリシー
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
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Stack       = "tuun"
  }

  # Lambda 関数名のプレフィックス
  lambda_prefix = "${var.project_name}-${var.environment}"
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
