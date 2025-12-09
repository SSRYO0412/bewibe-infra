# =============================================================================
# Cognito Module Variables
# =============================================================================

variable "user_pool_name" {
  description = "Cognito User Pool 名"
  type        = string
}

variable "password_minimum_length" {
  description = "パスワード最小長"
  type        = number
  default     = 8
}

variable "password_require_lowercase" {
  description = "小文字必須"
  type        = bool
  default     = true
}

variable "password_require_numbers" {
  description = "数字必須"
  type        = bool
  default     = true
}

variable "password_require_symbols" {
  description = "記号必須"
  type        = bool
  default     = false
}

variable "password_require_uppercase" {
  description = "大文字必須"
  type        = bool
  default     = true
}

variable "temporary_password_validity_days" {
  description = "一時パスワード有効期限（日）"
  type        = number
  default     = 7
}

variable "mfa_configuration" {
  description = "MFA 設定 (OFF/ON/OPTIONAL)"
  type        = string
  default     = "OFF"
}

variable "lambda_config" {
  description = "Lambda Trigger 設定"
  type        = map(string)
  default     = null
}

variable "create_app_client" {
  description = "App Client を作成するか"
  type        = bool
  default     = true
}

variable "app_client_name" {
  description = "App Client 名"
  type        = string
  default     = "app-client"
}

variable "generate_client_secret" {
  description = "クライアントシークレットを生成するか"
  type        = bool
  default     = false
}

variable "explicit_auth_flows" {
  description = "許可する認証フロー"
  type        = list(string)
  default     = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]
}

variable "access_token_validity" {
  description = "アクセストークン有効期限（分）"
  type        = number
  default     = 60
}

variable "id_token_validity" {
  description = "ID トークン有効期限（分）"
  type        = number
  default     = 60
}

variable "refresh_token_validity" {
  description = "リフレッシュトークン有効期限（日）"
  type        = number
  default     = 30
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
