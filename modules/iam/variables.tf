# =============================================================================
# IAM Module Variables
# =============================================================================

variable "role_name" {
  description = "IAM ロール名"
  type        = string
}

variable "trusted_services" {
  description = "信頼するサービス"
  type        = list(string)
  default     = ["lambda.amazonaws.com"]
}

variable "create_policy" {
  description = "カスタムポリシーを作成するか"
  type        = bool
  default     = false
}

variable "policy_name" {
  description = "ポリシー名"
  type        = string
  default     = ""
}

variable "policy_description" {
  description = "ポリシー説明"
  type        = string
  default     = ""
}

variable "policy_document" {
  description = "ポリシードキュメント (JSON)"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "アタッチする AWS 管理ポリシー ARN"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
