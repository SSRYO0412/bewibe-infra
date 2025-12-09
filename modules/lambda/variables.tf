# =============================================================================
# Lambda Module Variables
# =============================================================================

variable "function_name" {
  description = "Lambda 関数名"
  type        = string
}

variable "role_arn" {
  description = "Lambda 実行ロール ARN"
  type        = string
}

variable "handler" {
  description = "ハンドラ"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "ランタイム"
  type        = string
  default     = "python3.13"
}

variable "timeout" {
  description = "タイムアウト（秒）"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "メモリサイズ（MB）"
  type        = number
  default     = 256
}

variable "filename" {
  description = "デプロイパッケージのパス"
  type        = string
}

variable "source_code_hash" {
  description = "ソースコードのハッシュ"
  type        = string
}

variable "environment_variables" {
  description = "環境変数"
  type        = map(string)
  default     = {}
}

variable "vpc_config" {
  description = "VPC 設定"
  type = object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })
  default = null
}

variable "create_log_group" {
  description = "CloudWatch Log Group を作成するか"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "ログ保持期間（日）"
  type        = number
  default     = 30
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
