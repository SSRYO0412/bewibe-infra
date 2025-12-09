# =============================================================================
# Shared Stack - Main Configuration
# =============================================================================
# 共通基盤リソースを管理するスタック
# - CloudTrail
# - AWS Config (オプション)
# - Parameter Store パラメータ
# - Secrets Manager シークレット
# =============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
    Stack       = "shared"
  }
}

# =============================================================================
# Data Sources
# =============================================================================

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# =============================================================================
# Resources
# =============================================================================

# TODO: Phase 5 で CloudTrail モジュールを呼び出し
# module "cloudtrail" {
#   source = "../../modules/monitoring"
#   ...
# }

# TODO: Phase 3 で Parameter Store / Secrets Manager リソースを追加
