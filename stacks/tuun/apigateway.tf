# =============================================================================
# API Gateway REST APIs
# =============================================================================
# TUUN アプリケーションで使用する API Gateway (6個)
#
# 注意: API Gateway のリソース/メソッド/統合は既存のものを維持
# Terraform は REST API 本体の管理のみ
#
# Phase 2-5 で terraform import を実行
# =============================================================================

# -----------------------------------------------------------------------------
# UserAPI
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.user_api 02fc5gnwoi

resource "aws_api_gateway_rest_api" "user_api" {
  name        = "UserAPI"
  description = "サインアップAPI"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Chat-API
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.chat_api kbodeqy5wa

resource "aws_api_gateway_rest_api" "chat_api" {
  name        = "TUUNapp-Chat-API"
  description = "AIチャット機能用API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Health-Profile-API
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.health_profile_api 70ubpe7e14

resource "aws_api_gateway_rest_api" "health_profile_api" {
  name        = "TUUNapp-Health-Profile-API"
  # descriptionは未設定

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Get-Gene-API
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.get_gene_api kxuyul35l4

resource "aws_api_gateway_rest_api" "get_gene_api" {
  name        = "TUUNapp-Get-Gene-API"
  description = "遺伝子データ取得専用API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Get-Blood-API
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.get_blood_api 7rk2qibxm6

resource "aws_api_gateway_rest_api" "get_blood_api" {
  name        = "TUUNapp-Get-Blood-API"
  description = "血液検査データ取得専用API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Gene-Transfer-API
# -----------------------------------------------------------------------------
# Import: terraform import aws_api_gateway_rest_api.gene_transfer_api 1ac2k99n71

resource "aws_api_gateway_rest_api" "gene_transfer_api" {
  name        = "TUUNapp-Gene-Transfer-API"
  # descriptionは未設定

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
