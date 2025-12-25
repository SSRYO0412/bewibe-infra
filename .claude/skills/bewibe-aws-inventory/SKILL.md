---
name: bewibe-aws-inventory
description: bewibe-infra プロジェクトの AWS リソース一覧と設定情報を提供します。Cognito、DynamoDB、Lambda、S3、API Gateway のリソース確認時に使用してください。
---

# AWS リソース棚卸しスキル

## 基本情報

| 項目 | 値 |
|------|-----|
| AWS アカウント ID | 295250016740 |
| リージョン | ap-northeast-1（東京） |
| 棚卸し日 | 2025-12-10 |

## Cognito

| 項目 | 値 |
|------|-----|
| User Pool ID | `ap-northeast-1_cwAKljjzb` |
| ユーザー数 | 12 |
| パスワードポリシー | 大文字・小文字・数字・記号 全て必須 |

**注意**: Cognito User Pool の `terraform import` は高リスク。data source での参照のみを推奨。

## DynamoDB テーブル（7 テーブル）

| テーブル名 | 用途 |
|-----------|------|
| `tuun-health-data` | 健康データ |
| `tuun-blood-data` | 血液検査データ |
| `tuun-gene-data` | 遺伝子データ |
| `tuun-chat-history` | チャット履歴 |
| `tuun-analysis-results` | 分析結果 |
| `health-checkup-records` | 健康診断記録 |
| `tuun-terraform-locks` | Terraform ロック管理 |

**PITR（Point-in-Time Recovery）**: 2025-12-10 に全テーブル有効化済み

## Lambda 関数（11 関数）

| 関数名 | ランタイム |
|--------|----------|
| `tuun-chat-api` | python3.13 |
| `tuun-health-api` | python3.13 |
| `tuun-blood-api` | python3.13 |
| `tuun-gene-api` | python3.13 |
| `tuun-analysis-api` | python3.13 |
| （他 6 関数） | python3.13 |

**要対応**: Lambda 環境変数に認証情報が平文で保存されている。Secrets Manager への移行が必要。

## S3 バケット（3 バケット）

| バケット名 | 用途 | 暗号化 |
|-----------|------|--------|
| 遺伝子データ用 | 遺伝子データ保存 | AES256 |
| 証明書用 | SSL 証明書管理 | AES256 |
| 一時転送用 | データ転送 | AES256 |

**要確認**: バージョニング機能が一部未有効化

## API Gateway（6 API）

REST API 形式で構成。各 Lambda 関数に対応。

## 確認コマンド

```bash
# Lambda 一覧
AWS_PROFILE=tuun aws lambda list-functions --query 'Functions[].FunctionName'

# DynamoDB テーブル一覧
AWS_PROFILE=tuun aws dynamodb list-tables

# S3 バケット一覧
AWS_PROFILE=tuun aws s3 ls

# Cognito User Pool 詳細
AWS_PROFILE=tuun aws cognito-idp describe-user-pool \
  --user-pool-id ap-northeast-1_cwAKljjzb
```

## 未対応の課題

| 課題 | 優先度 |
|------|--------|
| Lambda 環境変数の Secrets Manager 移行 | 高 |
| S3 バージョニング有効化 | 中 |
