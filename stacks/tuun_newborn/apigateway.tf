# =============================================================================
# API Gateway REST APIs
# =============================================================================
# TUUN Newborn アプリケーションで使用する API Gateway (8個)
# =============================================================================

# -----------------------------------------------------------------------------
# UserAPI-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "user_api" {
  name        = "UserAPI-newborn"
  description = "サインアップAPI (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Chat-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "chat_api" {
  name        = "TUUNapp-Chat-API-newborn"
  description = "AIチャット機能用API (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Health-Profile-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "health_profile_api" {
  name        = "TUUNapp-Health-Profile-API-newborn"
  description = "ヘルスプロファイルAPI (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Get-Gene-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "get_gene_api" {
  name        = "TUUNapp-Get-Gene-API-newborn"
  description = "遺伝子データ取得専用API (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Get-Blood-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "get_blood_api" {
  name        = "TUUNapp-Get-Blood-API-newborn"
  description = "血液検査データ取得専用API (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Gene-Transfer-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "gene_transfer_api" {
  name        = "TUUNapp-Gene-Transfer-API-newborn"
  description = "遺伝子データ移行API (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Intelligence-API-newborn
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "intelligence_api" {
  name        = "TUUNapp-Intelligence-API-newborn"
  description = "TUUN Intelligence API - Time-based personalized health advice (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# -----------------------------------------------------------------------------
# TUUNapp-Agent-API-newborn (Agent Architecture v8)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_rest_api" "agent_api" {
  name        = "TUUNapp-Agent-API-newborn"
  description = "TUUN Agent API - AI agent chat, memory, sync, and management (newborn)"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    ignore_changes = [policy]
  }
}
