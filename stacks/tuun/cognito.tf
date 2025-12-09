# =============================================================================
# Cognito User Pool
# =============================================================================
# TUUN アプリケーションで使用する Cognito User Pool
#
# 既存リソース:
# - User Pool ID: ap-northeast-1_cwAKljjzb
# - User Pool 名: User pool - e-g5uy
# - Lambda Trigger: PostConfirmation → CreateUserFunctionPython
#
# ⚠️ 注意: Cognito の terraform import は高リスクです。
# ユーザー認証に直結するため、設定ミスで全ユーザーに影響が出る可能性があります。
#
# 選択肢:
# A) Phase 2-6 で import する (高リスク)
# B) v1 では Terraform 管理対象外とし、data source で参照のみ (推奨)
# =============================================================================

# =============================================================================
# 選択肢 B: Data Source での参照のみ (推奨)
# =============================================================================
# Cognito を Terraform 管理外とし、必要な情報のみ data source で取得

# data "aws_cognito_user_pools" "main" {
#   name = "User pool - e-g5uy"  # 棚卸しで確認した名前
# }

# locals {
#   cognito_user_pool_id = var.cognito_user_pool_id
# }

# =============================================================================
# 選択肢 A: Terraform Import (高リスク - Phase 2-6)
# =============================================================================
# import 時のコマンド:
# terraform import aws_cognito_user_pool.main ap-northeast-1_cwAKljjzb
# terraform import aws_cognito_user_pool_client.main <user_pool_id>/<client_id>

# resource "aws_cognito_user_pool" "main" {
#   name = "User pool - e-g5uy"  # 棚卸しで確認した名前
#
#   # パスワードポリシー (棚卸しで確認後に設定)
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = false
#     require_uppercase = true
#   }
#
#   # MFA 設定 (棚卸しで確認後に設定)
#   mfa_configuration = "OFF"  # または "ON" / "OPTIONAL"
#
#   # Lambda Trigger
#   lambda_config {
#     post_confirmation = aws_lambda_function.create_user.arn
#   }
#
#   # スキーマ属性 (棚卸しで確認後に設定)
#   # schema {
#   #   attribute_data_type = "String"
#   #   name                = "email"
#   #   required            = true
#   #   mutable             = false
#   # }
#
#   tags = {
#     Name        = "TUUN User Pool"
#     Description = "TUUN アプリケーション用 Cognito User Pool"
#   }
# }

# resource "aws_cognito_user_pool_client" "main" {
#   name         = "tuun-app-client"  # 棚卸しで確認した名前
#   user_pool_id = aws_cognito_user_pool.main.id
#
#   # クライアント設定 (棚卸しで確認後に設定)
#   generate_secret = false
#
#   explicit_auth_flows = [
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_SRP_AUTH"
#   ]
#
#   # トークン有効期限 (棚卸しで確認後に設定)
#   access_token_validity  = 60  # 分
#   id_token_validity      = 60  # 分
#   refresh_token_validity = 30  # 日
#
#   token_validity_units {
#     access_token  = "minutes"
#     id_token      = "minutes"
#     refresh_token = "days"
#   }
# }

# =============================================================================
# Lambda Permission for Cognito Trigger
# =============================================================================

# TODO: Phase 2-6 (Cognito import 後) で有効化
# resource "aws_lambda_permission" "cognito_trigger" {
#   statement_id  = "AllowCognitoInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.create_user.function_name
#   principal     = "cognito-idp.amazonaws.com"
#   source_arn    = aws_cognito_user_pool.main.arn
# }
