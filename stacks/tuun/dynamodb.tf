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
# - test: テスト用
#
# Phase 2-2 で terraform import を実行
# =============================================================================

# TODO: Phase 2-2 で import 後にコメント解除
#
# terraform import aws_dynamodb_table.users Users
# terraform import aws_dynamodb_table.blood_results blood-results
# terraform import aws_dynamodb_table.gene_analysis_results gene-analysis-results
# terraform import aws_dynamodb_table.gene_analysis_audit gene-analysis-audit
# terraform import aws_dynamodb_table.gene_data_transfers gene-data-transfers
# terraform import aws_dynamodb_table.user_health_profile user-health-profile
# terraform import aws_dynamodb_table.test test

# resource "aws_dynamodb_table" "users" {
#   name         = "Users"
#   billing_mode = "PAY_PER_REQUEST"  # 棚卸しで確認後に設定
#   hash_key     = "id"               # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   point_in_time_recovery {
#     enabled = true  # 棚卸しで確認、有効化推奨
#   }
#
#   tags = {
#     Name        = "Users"
#     Description = "ユーザープロファイル"
#   }
# }

# resource "aws_dynamodb_table" "blood_results" {
#   name         = "blood-results"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   point_in_time_recovery {
#     enabled = true
#   }
#
#   tags = {
#     Name        = "blood-results"
#     Description = "血液検査結果"
#   }
# }

# resource "aws_dynamodb_table" "gene_analysis_results" {
#   name         = "gene-analysis-results"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   point_in_time_recovery {
#     enabled = true
#   }
#
#   tags = {
#     Name        = "gene-analysis-results"
#     Description = "遺伝子解析結果"
#   }
# }

# resource "aws_dynamodb_table" "gene_analysis_audit" {
#   name         = "gene-analysis-audit"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   tags = {
#     Name        = "gene-analysis-audit"
#     Description = "遺伝子解析監査ログ"
#   }
# }

# resource "aws_dynamodb_table" "gene_data_transfers" {
#   name         = "gene-data-transfers"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   tags = {
#     Name        = "gene-data-transfers"
#     Description = "データ移行追跡"
#   }
# }

# resource "aws_dynamodb_table" "user_health_profile" {
#   name         = "user-health-profile"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   point_in_time_recovery {
#     enabled = true
#   }
#
#   tags = {
#     Name        = "user-health-profile"
#     Description = "ヘルスプロファイル"
#   }
# }

# resource "aws_dynamodb_table" "test" {
#   name         = "test"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "id"  # 棚卸しで確認後に設定
#
#   attribute {
#     name = "id"
#     type = "S"
#   }
#
#   tags = {
#     Name        = "test"
#     Description = "テスト用"
#   }
# }
