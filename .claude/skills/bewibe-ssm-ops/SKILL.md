---
name: bewibe-ssm-ops
description: bewibe-infra プロジェクトの Secrets Manager / SSM Parameter Store の管理ルールを提供します。シークレットの更新、参照、注意事項について使用してください。
---

# Secrets / SSM 管理スキル

## 管理原則

**「Terraform = 箱だけ管理。値は手動」**

- Terraform で管理するのはシークレットの「リソース定義」のみ
- 実際の値は Terraform 外で手動管理（CLI または AWS コンソール）

## シークレット値の更新

```bash
AWS_PROFILE=tuun aws secretsmanager put-secret-value \
  --secret-id tuun/rawdata-credentials \
  --secret-string '{"KEY":"NEW_VALUE"}'
```

## SSM パラメータの更新

```bash
AWS_PROFILE=tuun aws ssm put-parameter \
  --name "/tuun/parameter-name" \
  --value "new-value" \
  --overwrite
```

## 禁止事項

| 操作 | 理由 |
|------|------|
| シークレット名の変更 | 削除→再作成になり、サービス停止の原因 |
| SSM パラメータ名の変更 | 同上 |
| Terraform での値の直接管理 | State ファイルに平文で保存されるため |

## 既存シークレット一覧

| シークレット ID | 用途 |
|----------------|------|
| `tuun/rawdata-credentials` | Rawdata 認証情報 |

## 新規シークレット作成時の手順

1. Terraform で `aws_secretsmanager_secret` リソースを定義
2. `terraform apply` でリソースを作成
3. AWS CLI で値を設定

```hcl
# 例: Terraform 定義
resource "aws_secretsmanager_secret" "claude_example" {
  name = "claude-example-secret"  # claude-* プレフィックス必須
}
```

```bash
# 値の設定
AWS_PROFILE=tuun aws secretsmanager put-secret-value \
  --secret-id claude-example-secret \
  --secret-string '{"api_key":"your-api-key"}'
```

## Claude Code 向けルール

### 実行可能

- シークレット値の参照（`aws secretsmanager get-secret-value`）
- SSM パラメータ値の参照（`aws ssm get-parameter`）
- 新規シークレット/パラメータの Terraform 定義作成

### 承認が必要

- シークレット値の更新（`put-secret-value`）
- SSM パラメータ値の更新（`put-parameter`）

### 実行不可

- シークレット/パラメータの削除
- 既存リソース名の変更
