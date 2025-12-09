# =============================================================================
# API Gateway REST Module Variables
# =============================================================================

variable "api_name" {
  description = "API 名"
  type        = string
}

variable "api_description" {
  description = "API 説明"
  type        = string
  default     = ""
}

variable "endpoint_types" {
  description = "エンドポイントタイプ"
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "create_deployment" {
  description = "デプロイメントを作成するか"
  type        = bool
  default     = false
}

variable "deployment_trigger" {
  description = "デプロイメントトリガー"
  type        = string
  default     = ""
}

variable "create_stage" {
  description = "ステージを作成するか"
  type        = bool
  default     = false
}

variable "stage_name" {
  description = "ステージ名"
  type        = string
  default     = "prod"
}

variable "access_log_destination_arn" {
  description = "アクセスログ出力先 ARN"
  type        = string
  default     = null
}

variable "access_log_format" {
  description = "アクセスログフォーマット"
  type        = string
  default     = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId"
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
