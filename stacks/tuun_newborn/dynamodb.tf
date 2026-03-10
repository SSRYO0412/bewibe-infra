# =============================================================================
# DynamoDB Tables
# =============================================================================
# TUUN Newborn アプリケーションで使用する DynamoDB テーブル (19個)
#
# 既存テーブル:
# - Users-newborn: ユーザープロファイル
# - blood-results-newborn: 血液検査結果
# - gene-analysis-results-newborn: 遺伝子解析結果
# - gene-analysis-audit-newborn: 監査ログ
# - gene-data-transfers-newborn: データ移行追跡
# - user-health-profile-newborn: ヘルスプロファイル
# - tuun-device-tokens-newborn: デバイストークン (プッシュ通知)
# - tuun-rate-limits-newborn: APIレート制限
# - tuun-eval-results-newborn: 評価パイプライン結果
#
# Agent Architecture v8 追加テーブル:
# - tuun-agent-memories-newborn: エージェントメモリ
# - tuun-agent-profiles-newborn: エージェントプロファイル
# - tuun-agent-chat-events-newborn: チャットイベント (SSE用)
# - tuun-agent-usage-newborn: 利用量管理
# - tuun-agent-device-sync-newborn: 端末設定同期
# - tuun-agent-chat-history-newborn: チャット履歴
# - tuun-subscriptions-newborn: サブスクリプション管理
# - tuun-agent-scheduled-jobs-newborn: スケジュールジョブ
#
# DataView Phase 2-4 追加テーブル:
# - tuun-healthkit-data-newborn: HealthKitデータ
# - tuun-health-scores-newborn: ヘルススコア
# =============================================================================

# -----------------------------------------------------------------------------
# Users-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "users" {
  name         = "Users-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# blood-results-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "blood_results" {
  name         = "blood-results-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "timestamp"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# gene-analysis-audit-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "gene_analysis_audit" {
  name         = "gene-analysis-audit-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "timestamp"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Purpose = "AuditLog"
  }
}

# -----------------------------------------------------------------------------
# gene-analysis-results-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "gene_analysis_results" {
  name         = "gene-analysis-results-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "timestamp"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# gene-data-transfers-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "gene_data_transfers" {
  name         = "gene-data-transfers-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# user-health-profile-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "user_health_profile" {
  name         = "user-health-profile-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "profileVersion"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "profileVersion"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = {
    Application = "TUUNNewbornApp"
  }
}

# -----------------------------------------------------------------------------
# tuun-device-tokens-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "device_tokens" {
  name         = "tuun-device-tokens-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "deviceToken"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "deviceToken"
    type = "S"
  }
}

# -----------------------------------------------------------------------------
# tuun-rate-limits-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "rate_limits" {
  name         = "tuun-rate-limits-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }
}

# -----------------------------------------------------------------------------
# tuun-eval-results-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "eval_results" {
  name         = "tuun-eval-results-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "composite_score"
    type = "N"
  }

  attribute {
    name = "skill_id"
    type = "S"
  }

  global_secondary_index {
    name            = "date-score-index"
    hash_key        = "pk"
    range_key       = "composite_score"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "skill-score-index"
    hash_key        = "skill_id"
    range_key       = "composite_score"
    projection_type = "ALL"
  }
}

# =============================================================================
# Agent Architecture v8 - DynamoDB Tables (8個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# tuun-agent-memories-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_memories" {
  name         = "tuun-agent-memories-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "sessionIdTs"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "sessionIdTs"
    type = "S"
  }

  attribute {
    name = "type"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  global_secondary_index {
    name            = "type-index"
    hash_key        = "type"
    range_key       = "timestamp"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-profiles-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_profiles" {
  name         = "tuun-agent-profiles-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "profileType"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "profileType"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-chat-events-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_chat_events" {
  name         = "tuun-agent-chat-events-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "jobId"
  range_key    = "eventId"

  attribute {
    name = "jobId"
    type = "S"
  }

  attribute {
    name = "eventId"
    type = "S"
  }

  ttl {
    attribute_name = "expiresAt"
    enabled        = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-usage-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_usage" {
  name         = "tuun-agent-usage-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "yearMonth"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "yearMonth"
    type = "S"
  }

  ttl {
    attribute_name = "expiresAt"
    enabled        = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-device-sync-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_device_sync" {
  name         = "tuun-agent-device-sync-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "typeId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "typeId"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-chat-history-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_chat_history" {
  name         = "tuun-agent-chat-history-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "sessIdMsgId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "sessIdMsgId"
    type = "S"
  }

  global_secondary_index {
    name            = "session-index"
    hash_key        = "userId"
    range_key       = "sessIdMsgId"
    projection_type = "KEYS_ONLY"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-subscriptions-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "subscriptions" {
  name         = "tuun-subscriptions-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "subscriptionType"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "subscriptionType"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-agent-scheduled-jobs-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "agent_scheduled_jobs" {
  name         = "tuun-agent-scheduled-jobs-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "jobId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "jobId"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "scheduledTime"
    type = "S"
  }

  global_secondary_index {
    name            = "status-scheduledTime-index"
    hash_key        = "status"
    range_key       = "scheduledTime"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# =============================================================================
# DataView Phase 2-4 - DynamoDB Tables (2個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# tuun-healthkit-data-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "healthkit_data" {
  name         = "tuun-healthkit-data-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "date"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "date"
    type = "S"
  }

  ttl {
    attribute_name = "expiresAt"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-health-scores-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "health_scores" {
  name         = "tuun-health-scores-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "scoreKey"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "scoreKey"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }
}

# -----------------------------------------------------------------------------
# tuun-l1-events-newborn テーブル
# -----------------------------------------------------------------------------

resource "aws_dynamodb_table" "l1_events" {
  name         = "tuun-l1-events-newborn"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "eventId"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "eventId"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  point_in_time_recovery {
    enabled = true
  }
}
