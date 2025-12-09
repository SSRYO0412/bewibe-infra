# AWS リソース棚卸しドキュメント

## 概要

| 項目 | 値 |
|------|-----|
| AWS アカウント ID | 295250016740 |
| リージョン | ap-northeast-1 (東京) |
| 棚卸し実施日 | 2025-12-10 |
| 実施者 | Claude Code (自動棚卸し) |

---

## 1. Cognito

### User Pool

| 項目 | 値 |
|------|-----|
| User Pool ID | `ap-northeast-1_cwAKljjzb` |
| User Pool 名 | User pool - e-g5uy |
| ARN | `arn:aws:cognito-idp:ap-northeast-1:295250016740:userpool/ap-northeast-1_cwAKljjzb` |
| 作成日 | 2025-07-23 |
| 最終更新日 | 2025-12-09 |
| 推定ユーザー数 | 12 |
| MFA 設定 | OFF |
| 削除保護 | ACTIVE |
| ドメイン | ap-northeast-1cwakljjzb |
| ユーザー名属性 | email |
| 自動検証属性 | email |
| Lambda Trigger (PostConfirmation) | `CreateUserFunctionPython` |

#### パスワードポリシー

| 項目 | 値 |
|------|-----|
| 最小長 | 8 |
| 大文字必須 | ✅ |
| 小文字必須 | ✅ |
| 数字必須 | ✅ |
| 記号必須 | ✅ |
| 一時パスワード有効期間 | 7日 |

### App Client

| Client ID | Client 名 | Secret 有無 | 備考 |
|-----------|----------|-------------|------|
| `3uhtrfkr51ggh4gi5s597klinf` | TUUNapp | なし | メインアプリクライアント |

#### TUUNapp クライアント設定

| 項目 | 値 |
|------|-----|
| 作成日 | 2025-07-23 |
| Access Token 有効期間 | 60分 |
| ID Token 有効期間 | 60分 |
| Refresh Token 有効期間 | 5日 |
| 許可認証フロー | USER_PASSWORD_AUTH, USER_SRP_AUTH, REFRESH_TOKEN_AUTH, USER_AUTH |
| OAuth フロー | code |
| OAuth スコープ | email, openid, phone |
| コールバックURL | myapp://callback |

---

## 2. S3 バケット

| バケット名 | 用途 | バージョニング | 暗号化 | パブリックアクセス |
|-----------|------|:-------------:|:------:|:-----------------:|
| `tuunapp-gene-data-a7x9k3` | 遺伝子/血液データ | ❌ 無効 | ✅ AES256 | ✅ 全ブロック |
| `tuun-certificates` | mTLS証明書 | ❌ 無効 | ✅ AES256 | ✅ 全ブロック |
| `gene-data-temporary-transfer-a7x9k3` | データ移行用 | ❌ 無効 | ✅ AES256 | ✅ 全ブロック |

### ⚠️ 要対応事項
- **バージョニングが全バケットで無効**
- 本番データを扱う `tuunapp-gene-data-a7x9k3` は特にバージョニング有効化を推奨

---

## 3. DynamoDB テーブル

| テーブル名 | Hash Key | Range Key | 課金モード | Item数 | PITR |
|-----------|----------|-----------|----------|:------:|:----:|
| `Users` | id (S) | - | PAY_PER_REQUEST | 8 | ✅ |
| `blood-results` | userId (S) | timestamp (S) | PAY_PER_REQUEST | 5 | ✅ |
| `gene-analysis-results` | userId (S) | timestamp (S) | PAY_PER_REQUEST | 16 | ✅ |
| `gene-analysis-audit` | userId (S) | timestamp (S) | PAY_PER_REQUEST | 86 | ✅ |
| `gene-data-transfers` | userId (S) | - | PAY_PER_REQUEST | 0 | ✅ |
| `user-health-profile` | userId (S) | profileVersion (S) | PAY_PER_REQUEST | 3 | ✅ |
| `test` | ID (S) | - | PAY_PER_REQUEST | 0 | ❌ |

### ✅ PITR 有効化完了 (2025-12-10)
- `test` テーブル以外の全テーブルで PITR を有効化済み

---

## 4. Lambda 関数

| 関数名 | ランタイム | ハンドラ | メモリ | タイムアウト |
|--------|----------|---------|:------:|:-----------:|
| `CreateUserFunctionPython` | python3.13 | lambda_function.lambda_handler | 128MB | 15秒 |
| `BulkRegisterUsersFunction` | python3.13 | bulk_register_lambda.lambda_handler | 256MB | 300秒 |
| `chat-api-function` | python3.13 | lambda_function.lambda_handler | 128MB | 60秒 |
| `HealthProfileFunction` | python3.13 | lambda_function.lambda_handler | 128MB | 3秒 |
| `GetGeneDataFunction` | python3.13 | lambda_function.lambda_handler | 128MB | 3秒 |
| `GetGeneRawdataFunction` | python3.13 | lambda_function.lambda_handler | 128MB | 3秒 |
| `GetBloodDataFunction` | python3.13 | lambda_function.lambda_handler | 128MB | 3秒 |
| `blood-analysis-function` | python3.13 | lambda_function.lambda_handler | 256MB | 15秒 |
| `gene-analysis-evidence-function` | python3.13 | lambda_function.lambda_handler | 256MB | 10秒 |
| `ConvertGeneTextToJsonFunction` | python3.13 | index.handler | 128MB | 3秒 |
| `PrepareGeneDataTransferFunction` | python3.13 | lambda_function.lambda_handler | 128MB | 3秒 |

### Lambda 環境変数

| 関数名 | 環境変数 |
|--------|---------|
| `chat-api-function` | ENVIRONMENT=prod, MAX_MESSAGE_LENGTH=1000, PII_SALT=*** |
| `GetGeneRawdataFunction` | BASE_URL, USER_ID, PASSWORD, API_KEY (⚠️ 平文で保存) |
| `gene-analysis-evidence-function` | BACKUP_RETENTION_HOURS=0, DELETE_RAW_DATA=true |
| `PrepareGeneDataTransferFunction` | BUCKET_NAME, PRESIGNED_URL_EXPIRY=3600, MAX_DOWNLOAD_ATTEMPTS=3 |

### ⚠️ 要対応事項
- **`GetGeneRawdataFunction` の環境変数に認証情報が平文で保存されている**
- Secrets Manager または Parameter Store への移行を強く推奨

### Lambda IAM ロール

| 関数名 | IAM ロール |
|--------|-----------|
| `CreateUserFunctionPython` | CreateUserFunctionPython-role-qjfwg5bz |
| `BulkRegisterUsersFunction` | BulkRegisterUsersFunction-role-spl7nnrc |
| `chat-api-function` | chat-api-function-role-bunthz97 |
| `HealthProfileFunction` | HealthProfileFunction-role-3ofri2ax |
| `GetGeneDataFunction` | GetGeneDataFunction-role-euxr4mph |
| `GetGeneRawdataFunction` | GetGeneRawdataFunction-role-2haeygqb |
| `GetBloodDataFunction` | GetBloodDataFunction-role-ssowtbg7 |
| `blood-analysis-function` | blood-analysis-function-role-963k0ae6 |
| `gene-analysis-evidence-function` | gene-analysis-evidence-function-role-zu9t9yyh |
| `ConvertGeneTextToJsonFunction` | ConvertGeneTextToJsonFunction-role-btzpebw1 |
| `PrepareGeneDataTransferFunction` | PrepareGeneDataTransferFunction-role-98qt8r6h |

---

## 5. API Gateway (REST API)

| API 名 | API ID | ステージ | エンドポイント |
|--------|--------|---------|---------------|
| `UserAPI` | `02fc5gnwoi` | dev | `https://02fc5gnwoi.execute-api.ap-northeast-1.amazonaws.com/dev` |
| `TUUNapp-Chat-API` | `kbodeqy5wa` | prod | `https://kbodeqy5wa.execute-api.ap-northeast-1.amazonaws.com/prod` |
| `TUUNapp-Health-Profile-API` | `70ubpe7e14` | prod | `https://70ubpe7e14.execute-api.ap-northeast-1.amazonaws.com/prod` |
| `TUUNapp-Get-Gene-API` | `kxuyul35l4` | prod | `https://kxuyul35l4.execute-api.ap-northeast-1.amazonaws.com/prod` |
| `TUUNapp-Get-Blood-API` | `7rk2qibxm6` | prod | `https://7rk2qibxm6.execute-api.ap-northeast-1.amazonaws.com/prod` |
| `TUUNapp-Gene-Transfer-API` | `1ac2k99n71` | prod | `https://1ac2k99n71.execute-api.ap-northeast-1.amazonaws.com/prod` |

### API エンドポイント構成

すべての API は **REGIONAL** エンドポイントタイプを使用

---

## 6. Secrets Manager

| シークレット名 | 用途 | Terraform管理 |
|--------------|------|:-------------:|
| `tuunapp/openai-api-key` | OpenAI API キー | ❌ |
| `tuun/rawdata-credentials` | 外部API認証情報 | ✅ |

---

## 7. 監査・ログ

### CloudTrail

| 項目 | 値 |
|------|-----|
| 状態 | ✅ **有効** |
| Trail名 | `tuun-cloudtrail` |
| ログバケット | `tuun-cloudtrail-logs-295250016740` |
| マルチリージョン | No |
| グローバルサービス | Yes |

### AWS Config

| 項目 | 値 |
|------|-----|
| 状態 | ❌ **未設定** |

---

## 8. セキュリティ上の懸念事項

### 🔴 高優先度

1. **Lambda 環境変数に認証情報が平文で保存**
   - 対象: `GetGeneRawdataFunction`
   - 内容: BASE_URL, USER_ID, PASSWORD, API_KEY
   - 対策: Secrets Manager または Parameter Store (SecureString) へ移行

### 🟡 中優先度

2. ~~**DynamoDB PITR が大部分のテーブルで無効**~~ ✅ 対応済み (2025-12-10)
   - 対象: Users, blood-results, gene-analysis-results, user-health-profile 等
   - 対策: ~~本番データを扱うテーブルで PITR を有効化~~ → 有効化完了

3. ~~**S3 バージョニングが全バケットで無効**~~ ✅ 対応済み (2025-12-10)
   - 対象: ~~全3バケット~~ → `tuunapp-gene-data-a7x9k3`, `tuun-certificates` で有効化
   - 注: `gene-data-temporary-transfer-a7x9k3` は一時データのためスキップ

4. ~~**CloudTrail / AWS Config が未設定**~~ ✅ CloudTrail対応済み (2025-12-10)
   - CloudTrail: `tuun-cloudtrail` 有効化
   - AWS Config: 未設定（コスト要検討）

---

## 変更履歴

| 日付 | 変更者 | 内容 |
|------|-------|------|
| 2025-12-10 | Claude Code | 初版作成（自動棚卸し） |
| 2025-12-10 | Claude Code | DynamoDB PITR有効化（6テーブル） |
| 2025-12-10 | Claude Code | S3バージョニング有効化（2バケット） |
| 2025-12-10 | Claude Code | CloudTrail有効化 |
| 2025-12-10 | Claude Code | GitHub OIDC + CI設定 |
