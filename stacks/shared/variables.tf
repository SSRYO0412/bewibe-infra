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
  default     = "bewibe"
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
