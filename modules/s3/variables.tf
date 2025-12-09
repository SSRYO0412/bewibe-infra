# =============================================================================
# S3 Module Variables
# =============================================================================

variable "bucket_name" {
  description = "S3 バケット名"
  type        = string
}

variable "versioning_enabled" {
  description = "バージョニングを有効にするか"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "暗号化アルゴリズム (AES256/aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS キー ID (aws:kms 使用時)"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "バケットキーを有効にするか"
  type        = bool
  default     = false
}

variable "block_public_acls" {
  description = "パブリック ACL をブロック"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "パブリックポリシーをブロック"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "パブリック ACL を無視"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "パブリックバケットを制限"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "ライフサイクルルール"
  type = list(object({
    id                                  = string
    status                              = string
    expiration_days                     = optional(number)
    noncurrent_version_expiration_days  = optional(number)
  }))
  default = []
}

variable "tags" {
  description = "リソースタグ"
  type        = map(string)
  default     = {}
}
