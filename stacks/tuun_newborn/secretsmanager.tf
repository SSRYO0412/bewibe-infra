# =============================================================================
# Secrets Manager
# =============================================================================
# TUUN Newborn アプリケーションの認証情報（秘密）を安全に管理
#
# 重要: Terraform では「箱」のみ管理。秘密値は以下で投入:
#   aws secretsmanager put-secret-value \
#     --secret-id <secret-name> \
#     --secret-string '{"KEY":"VALUE"}'
#
# 原則: 秘密の平文を .tf / .tfvars / .tfstate に載せない
# =============================================================================

# -----------------------------------------------------------------------------
# GetGeneRawdataFunction-newborn 用認証情報
# -----------------------------------------------------------------------------
# 外部API（遺伝子データ取得）への認証情報
#
# 格納する値:
#   - USER_ID: 外部API認証用ユーザーID
#   - PASSWORD: 外部API認証用パスワード
#   - API_KEY: 外部APIキー
#   - BASE_URL: 外部APIベースURL
#
# 投入コマンド例:
#   AWS_PROFILE=tuun aws secretsmanager put-secret-value \
#     --secret-id tuun_newborn/rawdata-credentials \
#     --secret-string '{"USER_ID":"xxx","PASSWORD":"yyy","API_KEY":"zzz","BASE_URL":"https://..."}'

resource "aws_secretsmanager_secret" "rawdata_credentials" {
  name        = "tuun_newborn/rawdata-credentials"
  description = "GetGeneRawdataFunction-newborn用の外部API認証情報"

  # 削除時の復旧期間（誤削除防止）
  recovery_window_in_days = 7
}

# -----------------------------------------------------------------------------
# Anthropic API Key (Agent Architecture v8)
# -----------------------------------------------------------------------------
# Agent chat-processor / scheduled-executor が使用する Anthropic API キー
#
# 投入コマンド例:
#   AWS_PROFILE=tuun aws secretsmanager put-secret-value \
#     --secret-id tuun_newborn/anthropic-api-key \
#     --secret-string '{"ANTHROPIC_API_KEY":"sk-ant-..."}'

resource "aws_secretsmanager_secret" "anthropic_api_key" {
  name        = "tuun_newborn/anthropic-api-key"
  description = "Anthropic API key for agent LLM processing"

  recovery_window_in_days = 7
}

# -----------------------------------------------------------------------------
# CF Worker ↔ API GW HMAC Shared Secret (Layer 4)
# -----------------------------------------------------------------------------
# CF Worker がリクエストに X-CF-Signature ヘッダーを付与し、
# Lambda 関数が同じシークレットで検証する。
#
# 投入コマンド例:
#   AWS_PROFILE=tuun-terraform aws secretsmanager put-secret-value \
#     --secret-id tuun_newborn/cf-api-secret \
#     --secret-string '{"HMAC_KEY":"<64文字のランダム文字列>"}'

resource "aws_secretsmanager_secret" "cf_api_secret" {
  name        = "tuun_newborn/cf-api-secret"
  description = "HMAC shared secret for CF Worker ↔ Lambda request signing"

  recovery_window_in_days = 7
}
