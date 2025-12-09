# =============================================================================
# Variables
# =============================================================================

variable "aws_region" {
  description = "AWS リージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
  default     = "tuun"
}

variable "environment" {
  description = "環境名 (prod/stg/dev)"
  type        = string
  default     = "prod"
}

variable "aws_account_id" {
  description = "AWS アカウント ID"
  type        = string
  default     = "295250016740"
}

# =============================================================================
# Cognito Variables
# =============================================================================

variable "cognito_user_pool_id" {
  description = "既存の Cognito User Pool ID (import 時に使用)"
  type        = string
  default     = "ap-northeast-1_cwAKljjzb"
}

# =============================================================================
# Lambda Variables
# =============================================================================

variable "lambda_runtime" {
  description = "Lambda ランタイム"
  type        = string
  default     = "python3.13"
}

variable "lambda_timeout" {
  description = "Lambda タイムアウト (秒)"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda メモリサイズ (MB)"
  type        = number
  default     = 256
}
