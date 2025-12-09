# =============================================================================
# Monitoring Module Variables
# =============================================================================

# =============================================================================
# CloudTrail Variables
# =============================================================================

variable "create_cloudtrail" {
  description = "CloudTrail を作成するか"
  type        = bool
  default     = true
}

variable "cloudtrail_name" {
  description = "CloudTrail 名"
  type        = string
  default     = "main-trail"
}

variable "cloudtrail_s3_bucket_name" {
  description = "CloudTrail ログ用 S3 バケット名"
  type        = string
}

variable "include_global_service_events" {
  description = "グローバルサービスイベントを含めるか"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "マルチリージョントレイルにするか"
  type        = bool
  default     = false
}

# =============================================================================
# AWS Config Variables
# =============================================================================

variable "create_aws_config" {
  description = "AWS Config を作成するか"
  type        = bool
  default     = false
}

variable "config_recorder_name" {
  description = "Config Recorder 名"
  type        = string
  default     = "default"
}

variable "config_role_arn" {
  description = "Config 用 IAM ロール ARN"
  type        = string
  default     = ""
}

variable "config_delivery_channel_name" {
  description = "Config Delivery Channel 名"
  type        = string
  default     = "default"
}

variable "config_s3_bucket_name" {
  description = "Config ログ用 S3 バケット名"
  type        = string
  default     = ""
}

# =============================================================================
# Common Variables
# =============================================================================

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
