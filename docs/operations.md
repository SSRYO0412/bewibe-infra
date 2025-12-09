# 運用ルール

## 概要

本ドキュメントは bewibe-infra リポジトリの運用ルールを定義します。

| 項目 | 値 |
|------|-----|
| AWS アカウント | 295250016740 |
| リージョン | ap-northeast-1 |
| AWS Profile | `tuun-terraform` |
| Terraform State | S3 `tuun-terraform-state-295250016740` |

---

## スタック構成

| スタック | 用途 | CI/CD |
|---------|------|:-----:|
| `stacks/tuun` | TUUN アプリケーションリソース | ✅ 自動plan |
| `stacks/shared` | 共通基盤（CloudTrail, OIDC等） | ❌ 手動 |

---

## 日常運用フロー

### 変更を加える時

```
変更したい
    ↓
feature/* ブランチ作成
    ↓
.tf ファイル編集
    ↓
terraform plan で確認
    ↓
PR作成 → CI自動plan
    ↓
レビュー → mainマージ
    ↓
terraform apply（手動）
```

### stacks/tuun の変更

```bash
# 1. ブランチ作成
git checkout -b feature/add-new-resource

# 2. tfファイル編集後、ローカルで確認
cd stacks/tuun
AWS_PROFILE=tuun-terraform terraform plan

# 3. 問題なければコミット & PR
git add -A && git commit -m "feat: add new resource"
git push -u origin feature/add-new-resource
# → GitHub で PR作成、CI が自動で plan実行

# 4. マージ後に apply
git checkout main && git pull
AWS_PROFILE=tuun-terraform terraform apply
```

### stacks/shared の変更

shared スタックは変更頻度が低いため、CI対象外としています。

```bash
cd stacks/shared
AWS_PROFILE=tuun-terraform terraform plan
AWS_PROFILE=tuun-terraform terraform apply
git add -A && git commit -m "chore: update shared stack"
git push
```

---

## 前の状態に戻す方法

### apply前に戻したい

```bash
# ファイルの変更を破棄
git checkout .
```

### apply後に戻したい

```bash
# 直前のコミットを打ち消すコミット作成
git revert HEAD

# Terraformに反映
AWS_PROFILE=tuun-terraform terraform apply
```

### 特定のコミットまで戻したい

```bash
# コミット履歴確認
git log --oneline

# 特定コミットまで戻す（複数コミット分）
git revert HEAD~3..HEAD  # 直近3コミットを打ち消す
AWS_PROFILE=tuun-terraform terraform apply
```

---

## 禁止事項

| NG | 理由 |
|----|------|
| AWS コンソールで直接変更 | Terraformとの差分が生じる |
| State ファイルの直接編集 | 壊れる |
| `terraform destroy` の安易な実行 | 本番データ消える |
| Secrets/SSM の `name` 変更 | 削除→新規作成になりAPI停止 |

---

## コンソールで変更してしまった場合

```bash
# 1. 現状確認（差分が出る）
AWS_PROFILE=tuun-terraform terraform plan

# 2. 選択肢
# A: Terraform側を現状に合わせる → .tf を修正して plan が No changes になるまで調整
# B: AWS側をTerraformに合わせる → terraform apply で上書き
```

---

## Secrets / SSM の管理ルール

### 原則

**Terraform = 箱だけ管理。値は手動。**

| リソース | Terraform管理 | 値の管理 |
|---------|:-------------:|---------|
| `aws_secretsmanager_secret` | ✅ | CLI/コンソール |
| `aws_secretsmanager_secret_version` | ❌ | 定義しない |
| `aws_ssm_parameter` (String) | ✅ | 非秘密のみ `.tf` に書く |
| `aws_ssm_parameter` (SecureString) | ✅ | CLI/コンソール |

### シークレット値の更新

```bash
# Secrets Manager の値を更新
AWS_PROFILE=tuun aws secretsmanager put-secret-value \
  --secret-id tuun/rawdata-credentials \
  --secret-string '{"KEY":"NEW_VALUE"}'
```

### 名前は固定資産

SSM/Secrets の名前は一度デプロイしたら変更しない。

変更が必要な場合:
1. 新しい名前でリソース作成
2. アプリケーション側を切り替え
3. 古いリソースを削除

---

## よく使うコマンド

### 状態確認

```bash
# 現在のState確認
AWS_PROFILE=tuun-terraform terraform state list

# 特定リソースの詳細
AWS_PROFILE=tuun-terraform terraform state show aws_lambda_function.chat_api

# AWSとの差分確認
AWS_PROFILE=tuun-terraform terraform plan
```

### リソース追加（既存AWSリソースをTerraform管理下に）

```bash
# 1. .tf ファイルにリソース定義を書く
# 2. Import
AWS_PROFILE=tuun-terraform terraform import aws_s3_bucket.new_bucket bucket-name

# 3. plan で No changes になるまで .tf を調整
AWS_PROFILE=tuun-terraform terraform plan
```

---

## トラブルシューティング

### State Lock エラー

```bash
# ロックを強制解除
AWS_PROFILE=tuun-terraform terraform force-unlock -force <LOCK_ID>
```

### plan で予期しない destroy が出る

1. 絶対に apply しない
2. `.tf` ファイルを確認（リソース定義が消えていないか）
3. 必要なら `git diff` で変更を確認

### CI（GitHub Actions）が失敗する

1. Actions タブでログ確認
2. 権限エラーなら `terraform-ci-role` の IAM ポリシー確認
3. 認証エラーなら OIDC Provider 設定確認

---

## AI/自動化ツール向けクイックリファレンス

### 環境設定

```bash
cd /Users/sasakiryo/Documents/bewibe-infra
export AWS_PROFILE=tuun-terraform
```

### 基本操作

```bash
# tuun スタック操作
cd stacks/tuun
terraform init
terraform plan
terraform apply

# shared スタック操作
cd stacks/shared
terraform init
terraform plan
terraform apply
```

### 安全な変更手順

1. `terraform plan` で変更内容確認
2. `+ create` / `~ update` のみであることを確認
3. `- destroy` や `-/+ replace` がある場合は慎重に判断
4. 問題なければ `terraform apply`

### Import パターン

```bash
# S3
terraform import aws_s3_bucket.name bucket-name

# DynamoDB
terraform import aws_dynamodb_table.name table-name

# Lambda
terraform import aws_lambda_function.name function-name

# API Gateway
terraform import aws_api_gateway_rest_api.name api-id

# Secrets Manager
terraform import aws_secretsmanager_secret.name arn:aws:secretsmanager:...
```

---

## ドキュメント一覧

| ドキュメント | 内容 |
|------------|------|
| `docs/aws-inventory.md` | AWSリソース一覧 |
| `docs/operations.md` | 本ドキュメント（運用ルール） |
| `README.md` | プロジェクト概要 |

---

## 連絡先

- インフラ担当: @SSRYO0412
