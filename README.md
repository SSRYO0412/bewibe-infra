# bewibe-infra

Bewibe/TUUN プロジェクトの AWS インフラストラクチャを Terraform で管理するリポジトリです。

## 概要

| 項目 | 値 |
|------|-----|
| AWS アカウント ID | 295250016740 |
| リージョン | ap-northeast-1 (東京) |
| Terraform バージョン | >= 1.0 |
| AWS Provider バージョン | ~> 5.0 |

## ディレクトリ構成

```
bewibe-infra/
├── modules/                    # 再利用可能な Terraform モジュール
│   ├── cognito/               # Cognito User Pool
│   ├── dynamodb/              # DynamoDB テーブル
│   ├── lambda/                # Lambda 関数
│   ├── api-gateway-rest/      # REST API Gateway
│   ├── s3/                    # S3 バケット
│   ├── iam/                   # IAM ロール・ポリシー
│   └── monitoring/            # CloudTrail, AWS Config
│
├── stacks/                     # 環境・プロジェクト別スタック
│   ├── shared/                # 共通基盤（State管理、監査ログ等）
│   ├── tuun/                  # TUUN アプリケーション
│   └── fuud/                  # FUUD アプリケーション（将来用）
│
├── lambda-src/                 # Lambda 関数のソースコード
│   └── tuun/                  # TUUN 用 Lambda
│
├── docs/                       # ドキュメント
│   ├── aws-inventory.md       # AWS リソース棚卸し
│   ├── operations.md          # 運用ルール
│   └── import-guide.md        # terraform import 手順
│
└── .github/workflows/          # CI/CD (GitHub Actions)
    ├── terraform-plan.yml     # PR 時の plan 実行
    └── terraform-apply.yml    # main マージ時の apply 実行
```

## セットアップ手順

### 前提条件

- Terraform >= 1.0 がインストール済み
- AWS CLI がインストール・設定済み
- 適切な IAM 権限を持つ AWS 認証情報

### 初期設定

1. リポジトリをクローン

```bash
git clone git@github.com:SSRYO0412/bewibe-infra.git
cd bewibe-infra
```

2. Terraform State 用の S3 バケットと DynamoDB テーブルが作成済みであることを確認

```bash
# S3 バケット確認
aws s3 ls s3://tuun-terraform-state-295250016740

# DynamoDB テーブル確認
aws dynamodb describe-table --table-name tuun-terraform-locks
```

3. 各スタックで Terraform を初期化

```bash
# shared スタック
cd stacks/shared
terraform init

# tuun スタック
cd ../tuun
terraform init
```

## 運用ルール

### ブランチ戦略

- `main`: 本番環境に適用される構成
- `feature/*`: 機能開発用ブランチ

### 変更フロー

1. `feature/*` ブランチを作成
2. 変更を加えてコミット
3. Pull Request を作成
4. CI で `terraform plan` が自動実行される
5. レビュー後、`main` にマージ
6. CI で `terraform apply` が実行される（承認ゲート付き）

### 禁止事項

- AWS コンソールからの直接変更
- `terraform apply` の手動実行（緊急時を除く）
- State ファイルの直接編集

## スタック

### shared

共通基盤を管理：

- Terraform State 用 S3 バケット（別途作成済み前提）
- State Lock 用 DynamoDB テーブル（別途作成済み前提）
- CloudTrail
- AWS Config（オプション）
- Parameter Store パラメータ
- Secrets Manager シークレット

### tuun

TUUN アプリケーションのリソースを管理：

- Cognito User Pool
- DynamoDB テーブル（7つ）
- Lambda 関数（11個）
- API Gateway（6つ）
- S3 バケット（3つ）
- IAM ロール・ポリシー

### fuud（将来用）

FUUD アプリケーションのリソースを管理（未実装）

## ドキュメント

- [AWS リソース棚卸し](docs/aws-inventory.md) - リソース一覧と設定詳細
- [運用ルール](docs/operations.md) - 日常運用フロー、変更手順、トラブルシューティング
- [terraform import 手順](docs/import-guide.md) ※作成予定
- [障害対応手順](docs/incident-response.md) ※作成予定

> **AI/自動化ツール向け**: 運用コマンドのクイックリファレンスは [docs/operations.md](docs/operations.md) の末尾を参照

## 注意事項

### Cognito import について

Cognito User Pool の terraform import は高リスクです。
v1 では Terraform 管理対象外とし、data source で参照のみとすることを推奨します。

### State 管理

- State は S3 `tuun-terraform-state-295250016740` に保存
- State Lock は DynamoDB `tuun-terraform-locks` で管理
- State ファイルへの直接アクセスは最小限に

## ライセンス

Private - Bewibe Inc.
