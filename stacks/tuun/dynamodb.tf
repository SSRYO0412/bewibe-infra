# =============================================================================
# DynamoDB Tables
# =============================================================================
# TUUN アプリケーションで使用する DynamoDB テーブル
#
# 既存テーブル:
# - Users: ユーザープロファイル
# - blood-results: 血液検査結果
# - gene-analysis-results: 遺伝子解析結果
# - gene-analysis-audit: 監査ログ
# - gene-data-transfers: データ移行追跡
# - user-health-profile: ヘルスプロファイル
#
# Phase 2-2 で terraform import を実行
# =============================================================================

# -----------------------------------------------------------------------------
# Users テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.users Users

resource "aws_dynamodb_table" "users" {
  name         = "Users"
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
# blood-results テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.blood_results blood-results

resource "aws_dynamodb_table" "blood_results" {
  name         = "blood-results"
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
# gene-analysis-audit テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.gene_analysis_audit gene-analysis-audit

resource "aws_dynamodb_table" "gene_analysis_audit" {
  name         = "gene-analysis-audit"
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
# gene-analysis-results テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.gene_analysis_results gene-analysis-results

resource "aws_dynamodb_table" "gene_analysis_results" {
  name         = "gene-analysis-results"
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
# gene-data-transfers テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.gene_data_transfers gene-data-transfers

resource "aws_dynamodb_table" "gene_data_transfers" {
  name         = "gene-data-transfers"
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
# user-health-profile テーブル
# -----------------------------------------------------------------------------
# Import: terraform import aws_dynamodb_table.user_health_profile user-health-profile

resource "aws_dynamodb_table" "user_health_profile" {
  name         = "user-health-profile"
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
    Application = "TUUNapp"
  }
}
