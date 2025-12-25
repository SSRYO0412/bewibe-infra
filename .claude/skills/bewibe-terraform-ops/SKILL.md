---
name: bewibe-terraform-ops
description: bewibe-infra プロジェクトの Terraform 運用をサポートします。terraform plan/apply、state 確認、変更フロー、巻き戻し手順について使用してください。
---

# Terraform 運用スキル

## 環境情報

| 項目 | 値 |
|------|-----|
| AWS アカウント ID | 295250016740 |
| リージョン | ap-northeast-1（東京） |
| AWS プロファイル | `tuun-terraform` |
| State 保存先 | S3 `tuun-terraform-state-295250016740` |
| ロック管理 | DynamoDB `tuun-terraform-locks` |

## スタック構成

| スタック | 用途 | 管理方法 |
|----------|------|----------|
| `stacks/tuun` | TUUN アプリケーション | CI/CD 自動化 |
| `stacks/shared` | CloudTrail/OIDC 等の共有基盤 | 手動管理 |

## 基本コマンド

### Plan（変更確認）

```bash
cd stacks/tuun
AWS_PROFILE=tuun-terraform terraform plan
```

### Apply（変更適用）- ユーザー承認必須

```bash
AWS_PROFILE=tuun-terraform terraform apply
```

### State 確認

```bash
# リソース一覧
terraform state list

# 特定リソースの詳細
terraform state show aws_lambda_function.chat_api
```

### Import

```bash
terraform import aws_s3_bucket.new_bucket bucket-name
```

### ロック解除（緊急時のみ）

```bash
terraform force-unlock -force <LOCK_ID>
```

## 変更フロー

1. `feature/*` ブランチを作成
2. `.tf` ファイルを編集
3. `terraform plan` で確認
4. PR 作成 → CI 自動実行
5. レビュー → main マージ
6. `terraform apply`（ユーザー承認後）

## 巻き戻し手順

| 状態 | 方法 |
|------|------|
| Apply 前 | `git checkout .` で破棄 |
| Apply 後 | `git revert HEAD` で打ち消し |
| 複数コミット戻し | `git revert HEAD~3..HEAD` |

## 禁止事項

- AWS コンソールでの直接変更
- State ファイルの直接編集
- `terraform destroy` の安易な実行
- Secrets/SSM の名前変更

## Claude Code 向けルール

### 実行可能

- `terraform plan` の実行
- `terraform state list / show` の実行
- `terraform import` の実行
- Terraform 定義（.tf ファイル）の作成・編集

### 承認が必要

- `terraform apply` → **必ず plan 結果を提示し、ユーザーの明示的な承認を得てから実行**

### 実行不可

- `terraform destroy`（人間が実行）
- 既存 TUUN リソースの変更（`claude-*` プレフィックス以外）

### 命名ルール

- Claude が作成するリソースは **`claude-*` プレフィックス必須**
