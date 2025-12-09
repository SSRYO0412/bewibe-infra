# =============================================================================
# Cognito Module
# =============================================================================
# Cognito User Pool を作成する再利用可能モジュール
# =============================================================================

resource "aws_cognito_user_pool" "this" {
  name = var.user_pool_name

  # パスワードポリシー
  password_policy {
    minimum_length                   = var.password_minimum_length
    require_lowercase                = var.password_require_lowercase
    require_numbers                  = var.password_require_numbers
    require_symbols                  = var.password_require_symbols
    require_uppercase                = var.password_require_uppercase
    temporary_password_validity_days = var.temporary_password_validity_days
  }

  # MFA 設定
  mfa_configuration = var.mfa_configuration

  # Lambda Trigger
  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [var.lambda_config] : []
    content {
      post_confirmation = lookup(lambda_config.value, "post_confirmation", null)
      pre_sign_up       = lookup(lambda_config.value, "pre_sign_up", null)
      pre_authentication = lookup(lambda_config.value, "pre_authentication", null)
    }
  }

  tags = var.tags
}

resource "aws_cognito_user_pool_client" "this" {
  count = var.create_app_client ? 1 : 0

  name         = var.app_client_name
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = var.generate_client_secret

  explicit_auth_flows = var.explicit_auth_flows

  access_token_validity  = var.access_token_validity
  id_token_validity      = var.id_token_validity
  refresh_token_validity = var.refresh_token_validity

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}
