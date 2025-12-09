# =============================================================================
# DynamoDB Module Variables
# =============================================================================

variable "table_name" {
  description = "DynamoDB テーブル名"
  type        = string
}

variable "billing_mode" {
  description = "課金モード (PAY_PER_REQUEST/PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "パーティションキー名"
  type        = string
}

variable "range_key" {
  description = "ソートキー名"
  type        = string
  default     = null
}

variable "attributes" {
  description = "属性定義"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "GSI 定義"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    projection_type    = optional(string)
    non_key_attributes = optional(list(string))
  }))
  default = []
}

variable "ttl_attribute" {
  description = "TTL 属性名"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "PITR を有効にするか"
  type        = bool
  default     = true
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
