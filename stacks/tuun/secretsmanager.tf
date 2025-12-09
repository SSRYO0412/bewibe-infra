# =============================================================================
# Secrets Manager
# =============================================================================
# TUUN アプリケーションの認証情報（秘密）を安全に管理
#
# 重要: Terraform では「箱」のみ管理。秘密値は以下で投入:
#   aws secretsmanager put-secret-value \
#     --secret-id <secret-name> \
#     --secret-string '{"KEY":"VALUE"}'
#
# 原則: 秘密の平文を .tf / .tfvars / .tfstate に載せない
# =============================================================================

# -----------------------------------------------------------------------------
# GetGeneRawdataFunction 用認証情報
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
#     --secret-id tuun/rawdata-credentials \
#     --secret-string '{"USER_ID":"xxx","PASSWORD":"yyy","API_KEY":"zzz","BASE_URL":"https://..."}'

resource "aws_secretsmanager_secret" "rawdata_credentials" {
  name        = "tuun/rawdata-credentials"
  description = "GetGeneRawdataFunction用の外部API認証情報"

  # 削除時の復旧期間（誤削除防止）
  recovery_window_in_days = 7
}

