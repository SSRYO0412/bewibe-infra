# 運用ルール

## 概要

本ドキュメントは bewibe-infra リポジトリの運用ルールを定義します。

---

## スタック構成

| スタック | 用途 | CI/CD |
|---------|------|:-----:|
| `stacks/tuun` | TUUN アプリケーションリソース | ✅ 自動plan |
| `stacks/shared` | 共通基盤（CloudTrail, OIDC等） | ❌ 手動 |

---

## 変更フロー

### stacks/tuun の変更

1. `feature/*` ブランチを作成
2. 変更を加えてコミット
3. Pull Request を作成
4. **CI で `terraform plan` が自動実行される**
5. レビュー後、`main` にマージ
6. **ローカルで `terraform apply` を手動実行**

```bash
cd stacks/tuun
AWS_PROFILE=tuun-terraform terraform apply
```

### stacks/shared の変更

shared スタックは変更頻度が低いため、CI対象外としています。

1. ローカルで変更を加える
2. `terraform plan` で確認
3. `terraform apply` を手動実行
4. コミット & プッシュ

```bash
cd stacks/shared
AWS_PROFILE=tuun-terraform terraform plan
AWS_PROFILE=tuun-terraform terraform apply
```

---

## 禁止事項

- AWS コンソールからの直接変更
- State ファイルの直接編集
- `terraform destroy` の安易な実行
- Secrets Manager の `name` 変更（削除＆新規作成になる）

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

### 名前は固定資産

SSM/Secrets の名前は一度デプロイしたら変更しない。

変更が必要な場合:
1. 新しい名前でリソース作成
2. アプリケーション側を切り替え
3. 古いリソースを削除

---

## トラブルシューティング

### State Lock エラー

```bash
terraform force-unlock -force <LOCK_ID>
```

### Import 手順

```bash
# 既存リソースをStateに登録
terraform import <RESOURCE_ADDRESS> <RESOURCE_ID>
terraform plan  # No changes になるまで .tf を調整
```

---

## 連絡先

- インフラ担当: @SSRYO0412
