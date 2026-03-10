# =============================================================================
# Cognito User Pool
# =============================================================================
# TUUN Newborn アプリケーション用の新規 Cognito User Pool
#
# 既存の TUUN User Pool (ap-northeast-1_cwAKljjzb) とは完全に独立
# =============================================================================

# =============================================================================
# Cognito User Pool (新規作成)
# =============================================================================

module "cognito" {
  source = "../../modules/cognito"

  user_pool_name = "tuun-newborn-user-pool"

  # パスワードポリシー (既存 TUUN と同じ設定)
  password_minimum_length    = 8
  password_require_lowercase = true
  password_require_numbers   = true
  password_require_symbols   = false
  password_require_uppercase = true

  # MFA 設定
  mfa_configuration = "OFF"

  # App Client
  create_app_client = true
  app_client_name   = "TUUNNewbornApp"

  # Lambda Trigger: サインアップ後に CreateUserFunctionPython-newborn を起動
  lambda_config = {
    post_confirmation = aws_lambda_function.create_user.arn
  }

  tags = {
    Name        = "TUUN Newborn User Pool"
    Description = "TUUN Newborn アプリケーション用 Cognito User Pool"
  }
}

# =============================================================================
# Lambda Permission for Cognito Trigger
# =============================================================================

resource "aws_lambda_permission" "cognito_trigger" {
  statement_id  = "AllowCognitoInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_user.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = module.cognito.user_pool_arn
}
