# =============================================================================
# S3 Buckets
# =============================================================================
# TUUN アプリケーションで使用する S3 バケット
#
# 既存バケット:
# - tuunapp-gene-data-a7x9k3: 遺伝子/血液データ
# - tuun-certificates: mTLS 証明書
# - gene-data-temporary-transfer-a7x9k3: データ移行用
#
# Phase 2-1 で terraform import を実行
# =============================================================================

# TODO: Phase 2-1 で import 後にコメント解除
#
# terraform import aws_s3_bucket.gene_data tuunapp-gene-data-a7x9k3
# terraform import aws_s3_bucket.certificates tuun-certificates
# terraform import aws_s3_bucket.gene_data_transfer gene-data-temporary-transfer-a7x9k3

# resource "aws_s3_bucket" "gene_data" {
#   bucket = "tuunapp-gene-data-a7x9k3"
#
#   tags = {
#     Name        = "TUUN Gene Data"
#     Description = "遺伝子/血液データ保存用"
#   }
# }
#
# resource "aws_s3_bucket_versioning" "gene_data" {
#   bucket = aws_s3_bucket.gene_data.id
#   versioning_configuration {
#     status = "Enabled"  # 棚卸しで確認後に設定
#   }
# }
#
# resource "aws_s3_bucket_server_side_encryption_configuration" "gene_data" {
#   bucket = aws_s3_bucket.gene_data.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm = "AES256"
#     }
#   }
# }
#
# resource "aws_s3_bucket_public_access_block" "gene_data" {
#   bucket = aws_s3_bucket.gene_data.id
#
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }

# resource "aws_s3_bucket" "certificates" {
#   bucket = "tuun-certificates"
#
#   tags = {
#     Name        = "TUUN Certificates"
#     Description = "mTLS 証明書保存用"
#   }
# }

# resource "aws_s3_bucket" "gene_data_transfer" {
#   bucket = "gene-data-temporary-transfer-a7x9k3"
#
#   tags = {
#     Name        = "TUUN Gene Data Transfer"
#     Description = "データ移行用一時バケット"
#   }
# }
