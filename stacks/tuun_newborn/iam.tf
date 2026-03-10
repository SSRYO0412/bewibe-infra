# =============================================================================
# IAM Roles and Policies
# =============================================================================
# TUUN Newborn アプリケーションで使用する IAM ロール・ポリシー
#
# 各 Lambda 関数用に新規 IAM ロールを作成
# (既存の TUUN ロールとは独立)
# =============================================================================

# -----------------------------------------------------------------------------
# Lambda 共通の Assume Role Policy (Trust Policy)
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# -----------------------------------------------------------------------------
# Lambda 共通の基本実行ポリシー (CloudWatch Logs)
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "lambda_basic_execution" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# -----------------------------------------------------------------------------
# DynamoDB アクセスポリシー
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "dynamodb_full_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
    ]
    resources = [
      # 既存テーブル (9個)
      aws_dynamodb_table.users.arn,
      aws_dynamodb_table.blood_results.arn,
      aws_dynamodb_table.gene_analysis_results.arn,
      aws_dynamodb_table.gene_analysis_audit.arn,
      aws_dynamodb_table.gene_data_transfers.arn,
      aws_dynamodb_table.user_health_profile.arn,
      aws_dynamodb_table.device_tokens.arn,
      aws_dynamodb_table.rate_limits.arn,
      aws_dynamodb_table.eval_results.arn,
      "${aws_dynamodb_table.users.arn}/index/*",
      "${aws_dynamodb_table.blood_results.arn}/index/*",
      "${aws_dynamodb_table.gene_analysis_results.arn}/index/*",
      "${aws_dynamodb_table.gene_analysis_audit.arn}/index/*",
      "${aws_dynamodb_table.gene_data_transfers.arn}/index/*",
      "${aws_dynamodb_table.user_health_profile.arn}/index/*",
      "${aws_dynamodb_table.device_tokens.arn}/index/*",
      "${aws_dynamodb_table.rate_limits.arn}/index/*",
      "${aws_dynamodb_table.eval_results.arn}/index/*",
      # Agent Architecture v8 追加テーブル (8個)
      aws_dynamodb_table.agent_memories.arn,
      aws_dynamodb_table.agent_profiles.arn,
      aws_dynamodb_table.agent_chat_events.arn,
      aws_dynamodb_table.agent_usage.arn,
      aws_dynamodb_table.agent_device_sync.arn,
      aws_dynamodb_table.agent_chat_history.arn,
      aws_dynamodb_table.subscriptions.arn,
      aws_dynamodb_table.agent_scheduled_jobs.arn,
      "${aws_dynamodb_table.agent_memories.arn}/index/*",
      "${aws_dynamodb_table.agent_profiles.arn}/index/*",
      "${aws_dynamodb_table.agent_chat_events.arn}/index/*",
      "${aws_dynamodb_table.agent_usage.arn}/index/*",
      "${aws_dynamodb_table.agent_device_sync.arn}/index/*",
      "${aws_dynamodb_table.agent_chat_history.arn}/index/*",
      "${aws_dynamodb_table.subscriptions.arn}/index/*",
      "${aws_dynamodb_table.agent_scheduled_jobs.arn}/index/*",
    ]
  }
}

# -----------------------------------------------------------------------------
# S3 アクセスポリシー
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "s3_gene_data_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.gene_data.arn,
      "${aws_s3_bucket.gene_data.arn}/*",
      aws_s3_bucket.gene_data_transfer.arn,
      "${aws_s3_bucket.gene_data_transfer.arn}/*",
    ]
  }
}

# =============================================================================
# IAM Roles - 各 Lambda 関数用
# =============================================================================

# -----------------------------------------------------------------------------
# CreateUserFunctionPython-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "create_user" {
  name               = "CreateUserFunctionPython-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "create_user_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.create_user.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "create_user_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.create_user.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "create_user_s3" {
  name   = "S3Access"
  role   = aws_iam_role.create_user.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

# -----------------------------------------------------------------------------
# BulkRegisterUsersFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "bulk_register" {
  name               = "BulkRegisterUsersFunction-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "bulk_register_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.bulk_register.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "bulk_register_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.bulk_register.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "bulk_register_cognito" {
  name = "CognitoAccess"
  role = aws_iam_role.bulk_register.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:AdminCreateUser",
          "cognito-idp:AdminSetUserPassword",
          "cognito-idp:ListUsers",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# chat-api-function-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "chat_api" {
  name               = "chat-api-function-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "chat_api_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.chat_api.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "chat_api_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.chat_api.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "chat_api_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.chat_api.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# HealthProfileFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "health_profile" {
  name               = "HealthProfileFunction-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "health_profile_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.health_profile.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "health_profile_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.health_profile.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

# -----------------------------------------------------------------------------
# GetGeneDataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "get_gene_data" {
  name               = "GetGeneDataFunction-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "get_gene_data_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.get_gene_data.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "get_gene_data_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.get_gene_data.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "get_gene_data_s3" {
  name   = "S3Access"
  role   = aws_iam_role.get_gene_data.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

# -----------------------------------------------------------------------------
# GetGeneRawdataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "get_gene_rawdata" {
  name               = "GetGeneRawdataFunction-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "get_gene_rawdata_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.get_gene_rawdata.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "get_gene_rawdata_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.get_gene_rawdata.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "get_gene_rawdata_s3" {
  name   = "S3Access"
  role   = aws_iam_role.get_gene_rawdata.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

resource "aws_iam_role_policy" "get_gene_rawdata_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.get_gene_rawdata.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = [
          aws_secretsmanager_secret.rawdata_credentials.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "get_gene_rawdata_vpc" {
  name = "VPCAccess"
  role = aws_iam_role.get_gene_rawdata.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# GetBloodDataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "get_blood_data" {
  name               = "GetBloodDataFunction-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "get_blood_data_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.get_blood_data.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "get_blood_data_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.get_blood_data.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

# -----------------------------------------------------------------------------
# blood-analysis-function-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "blood_analysis" {
  name               = "blood-analysis-function-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "blood_analysis_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.blood_analysis.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "blood_analysis_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.blood_analysis.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "blood_analysis_s3" {
  name   = "S3Access"
  role   = aws_iam_role.blood_analysis.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

resource "aws_iam_role_policy" "blood_analysis_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.blood_analysis.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# gene-analysis-evidence-function-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "gene_analysis_evidence" {
  name               = "gene-analysis-evidence-fn-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "gene_analysis_evidence_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.gene_analysis_evidence.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "gene_analysis_evidence_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.gene_analysis_evidence.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "gene_analysis_evidence_s3" {
  name   = "S3Access"
  role   = aws_iam_role.gene_analysis_evidence.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

resource "aws_iam_role_policy" "gene_analysis_evidence_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.gene_analysis_evidence.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# ConvertGeneTextToJsonFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "convert_gene_text" {
  name               = "ConvertGeneTextToJson-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "convert_gene_text_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.convert_gene_text.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "convert_gene_text_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.convert_gene_text.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "convert_gene_text_s3" {
  name   = "S3Access"
  role   = aws_iam_role.convert_gene_text.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

# -----------------------------------------------------------------------------
# PrepareGeneDataTransferFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_iam_role" "prepare_gene_transfer" {
  name               = "PrepareGeneDataTransfer-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "prepare_gene_transfer_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.prepare_gene_transfer.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "prepare_gene_transfer_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.prepare_gene_transfer.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "prepare_gene_transfer_s3" {
  name   = "S3Access"
  role   = aws_iam_role.prepare_gene_transfer.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

# =============================================================================
# Intelligence / Claude 系 IAM ロール (3個)
# =============================================================================

# -----------------------------------------------------------------------------
# intelligence-api-lambda-newborn-role
# -----------------------------------------------------------------------------
# 使用: intelligence-api-function, intelligence-api-claude, chat-api-claude,
#       tuun-eval-pipeline, tuun-eval-self-repair (5関数で共有)

resource "aws_iam_role" "intelligence_api" {
  name               = "intelligence-api-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "intelligence_api_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.intelligence_api.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "intelligence_api_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.intelligence_api.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "intelligence_api_s3" {
  name   = "S3Access"
  role   = aws_iam_role.intelligence_api.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

resource "aws_iam_role_policy" "intelligence_api_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.intelligence_api.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = ["*"]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# intelligence-push-lambda-newborn-role
# -----------------------------------------------------------------------------

resource "aws_iam_role" "intelligence_push" {
  name               = "intelligence-push-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "intelligence_push_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.intelligence_push.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "intelligence_push_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.intelligence_push.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "intelligence_push_secrets" {
  name = "SecretsManagerRead"
  role = aws_iam_role.intelligence_push.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:ap-northeast-1:295250016740:secret:tuun_newborn/apns-config-*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "intelligence_push_lambda_invoke" {
  name = "LambdaInvoke"
  role = aws_iam_role.intelligence_push.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = [
          aws_lambda_function.intelligence_api.arn,
          aws_lambda_function.intelligence_api_claude.arn,
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# device-token-lambda-newborn-role
# -----------------------------------------------------------------------------

resource "aws_iam_role" "device_token" {
  name               = "device-token-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "device_token_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.device_token.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "device_token_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.device_token.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "device_token_secrets" {
  name = "SecretsManagerRead"
  role = aws_iam_role.device_token.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = "arn:aws:secretsmanager:ap-northeast-1:295250016740:secret:tuun_newborn/cf-api-secret-*"
      }
    ]
  })
}

# =============================================================================
# Agent Architecture v8 - IAM Roles (5個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# Agent DynamoDB アクセスポリシー (agent系7テーブルのみ)
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "agent_dynamodb_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Query",
      "dynamodb:Scan",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
    ]
    resources = [
      aws_dynamodb_table.agent_memories.arn,
      aws_dynamodb_table.agent_profiles.arn,
      aws_dynamodb_table.agent_chat_events.arn,
      aws_dynamodb_table.agent_usage.arn,
      aws_dynamodb_table.agent_device_sync.arn,
      aws_dynamodb_table.agent_chat_history.arn,
      aws_dynamodb_table.agent_scheduled_jobs.arn,
      aws_dynamodb_table.subscriptions.arn,
      "${aws_dynamodb_table.agent_memories.arn}/index/*",
      "${aws_dynamodb_table.agent_profiles.arn}/index/*",
      "${aws_dynamodb_table.agent_chat_events.arn}/index/*",
      "${aws_dynamodb_table.agent_usage.arn}/index/*",
      "${aws_dynamodb_table.agent_device_sync.arn}/index/*",
      "${aws_dynamodb_table.agent_chat_history.arn}/index/*",
      "${aws_dynamodb_table.agent_scheduled_jobs.arn}/index/*",
      "${aws_dynamodb_table.subscriptions.arn}/index/*",
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-api-lambda-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-chat-init, agent-chat-events, agent-usage, agent-chat-history,
#       agent-memory-api, agent-sync (6関数で共有)

resource "aws_iam_role" "agent_api" {
  name               = "agent-api-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_api_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_api.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_api_dynamodb" {
  name   = "AgentDynamoDBAccess"
  role   = aws_iam_role.agent_api.name
  policy = data.aws_iam_policy_document.agent_dynamodb_access.json
}

resource "aws_iam_role_policy" "agent_api_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_api.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_api_lambda_invoke" {
  name = "LambdaInvoke"
  role = aws_iam_role.agent_api.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = [
          aws_lambda_function.agent_chat_processor.arn,
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-processor-lambda-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-chat-processor, scheduled-executor (2関数で共有)

resource "aws_iam_role" "agent_processor" {
  name               = "agent-processor-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_processor_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_processor.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_processor_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.agent_processor.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "agent_processor_dataview_dynamodb" {
  name = "DataViewDynamoDBAccess"
  role = aws_iam_role.agent_processor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.healthkit_data.arn,
          "${aws_dynamodb_table.healthkit_data.arn}/index/*",
          aws_dynamodb_table.health_scores.arn,
          "${aws_dynamodb_table.health_scores.arn}/index/*",
          aws_dynamodb_table.l1_events.arn,
          "${aws_dynamodb_table.l1_events.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_processor_s3" {
  name = "S3Access"
  role = aws_iam_role.agent_processor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.gene_data.arn,
          "${aws_s3_bucket.gene_data.arn}/*",
          aws_s3_bucket.config.arn,
          "${aws_s3_bucket.config.arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_processor_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_processor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
        ]
        Resource = [
          aws_secretsmanager_secret.anthropic_api_key.arn,
          aws_secretsmanager_secret.cf_api_secret.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_processor_lambda_invoke" {
  name = "LambdaInvoke"
  role = aws_iam_role.agent_processor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
        ]
        Resource = [
          aws_lambda_function.agent_prepare_context.arn,
          aws_lambda_function.agent_gene_data.arn,
          aws_lambda_function.agent_score_engine.arn,
          aws_lambda_function.agent_healthkit_sync.arn,
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_processor_sns" {
  name = "SNSPublish"
  role = aws_iam_role.agent_processor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
        ]
        Resource = [
          "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-prepare-context-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-prepare-context (1関数)

resource "aws_iam_role" "agent_prepare_context" {
  name               = "agent-prepare-context-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_prepare_context_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_prepare_context.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_prepare_context_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.agent_prepare_context.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "agent_prepare_context_s3" {
  name   = "S3Access"
  role   = aws_iam_role.agent_prepare_context.name
  policy = data.aws_iam_policy_document.s3_gene_data_access.json
}

resource "aws_iam_role_policy" "agent_prepare_context_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_prepare_context.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# account-delete-lambda-newborn-role
# -----------------------------------------------------------------------------
# 使用: account-delete-handler (1関数)

resource "aws_iam_role" "account_delete" {
  name               = "account-delete-lambda-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "account_delete_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.account_delete.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "account_delete_dynamodb" {
  name   = "DynamoDBAccess"
  role   = aws_iam_role.account_delete.name
  policy = data.aws_iam_policy_document.dynamodb_full_access.json
}

resource "aws_iam_role_policy" "account_delete_s3" {
  name = "S3Access"
  role = aws_iam_role.account_delete.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
        ]
        Resource = [
          aws_s3_bucket.gene_data.arn,
          "${aws_s3_bucket.gene_data.arn}/*",
          aws_s3_bucket.certificates.arn,
          "${aws_s3_bucket.certificates.arn}/*",
          aws_s3_bucket.gene_data_transfer.arn,
          "${aws_s3_bucket.gene_data_transfer.arn}/*",
          aws_s3_bucket.config.arn,
          "${aws_s3_bucket.config.arn}/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "account_delete_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.account_delete.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

resource "aws_iam_role_policy" "account_delete_cognito" {
  name = "CognitoAccess"
  role = aws_iam_role.account_delete.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:AdminDeleteUser",
        ]
        Resource = [
          module.cognito.user_pool_arn,
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# subscription-webhook-newborn-role
# -----------------------------------------------------------------------------
# 使用: subscription-webhook (1関数)

resource "aws_iam_role" "subscription_webhook" {
  name               = "subscription-webhook-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "subscription_webhook_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.subscription_webhook.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "subscription_webhook_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.subscription_webhook.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
        ]
        Resource = [
          aws_dynamodb_table.subscriptions.arn,
          "${aws_dynamodb_table.subscriptions.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "subscription_webhook_sns" {
  name = "SNSPublish"
  role = aws_iam_role.subscription_webhook.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sns:Publish",
        ]
        Resource = [
          "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
        ]
      }
    ]
  })
}

# =============================================================================
# DataView Phase 2-4 - IAM Roles (5個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# agent-gene-data-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-gene-data (1関数) - 遺伝子データ読み取り専用

resource "aws_iam_role" "agent_gene_data_role" {
  name               = "agent-gene-data-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_gene_data_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_gene_data_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_gene_data_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.agent_gene_data_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.gene_analysis_results.arn,
          "${aws_dynamodb_table.gene_analysis_results.arn}/index/*",
          aws_dynamodb_table.gene_analysis_audit.arn,
          "${aws_dynamodb_table.gene_analysis_audit.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_gene_data_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_gene_data_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-blood-data-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-blood-data (1関数) - 血液データ読み取り専用

resource "aws_iam_role" "agent_blood_data_role" {
  name               = "agent-blood-data-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_blood_data_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_blood_data_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_blood_data_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.agent_blood_data_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.blood_results.arn,
          "${aws_dynamodb_table.blood_results.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_blood_data_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_blood_data_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-health-profile-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-health-profile-api (1関数) - ヘルスプロファイル読み書き

resource "aws_iam_role" "agent_health_profile_role" {
  name               = "agent-health-profile-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_health_profile_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_health_profile_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_health_profile_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.agent_health_profile_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.user_health_profile.arn,
          "${aws_dynamodb_table.user_health_profile.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_health_profile_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_health_profile_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-healthkit-sync-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-healthkit-sync (1関数) - HealthKitデータ書き込み

resource "aws_iam_role" "agent_healthkit_sync_role" {
  name               = "agent-healthkit-sync-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_healthkit_sync_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_healthkit_sync_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_healthkit_sync_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.agent_healthkit_sync_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.healthkit_data.arn,
          "${aws_dynamodb_table.healthkit_data.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_healthkit_sync_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_healthkit_sync_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# agent-score-engine-newborn-role
# -----------------------------------------------------------------------------
# 使用: agent-score-engine (1関数) - 複数テーブル読み取り + スコア書き込み

resource "aws_iam_role" "agent_score_engine_role" {
  name               = "agent-score-engine-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_score_engine_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_score_engine_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_score_engine_dynamodb_read" {
  name = "DynamoDBReadAccess"
  role = aws_iam_role.agent_score_engine_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.blood_results.arn,
          "${aws_dynamodb_table.blood_results.arn}/index/*",
          aws_dynamodb_table.healthkit_data.arn,
          "${aws_dynamodb_table.healthkit_data.arn}/index/*",
          aws_dynamodb_table.gene_analysis_results.arn,
          "${aws_dynamodb_table.gene_analysis_results.arn}/index/*",
          aws_dynamodb_table.user_health_profile.arn,
          "${aws_dynamodb_table.user_health_profile.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_score_engine_dynamodb_write" {
  name = "DynamoDBWriteAccess"
  role = aws_iam_role.agent_score_engine_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:BatchGetItem",
        ]
        Resource = [
          aws_dynamodb_table.health_scores.arn,
          "${aws_dynamodb_table.health_scores.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_score_engine_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_score_engine_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}

# =============================================================================
# agent-l1-api-newborn-role
# =============================================================================

resource "aws_iam_role" "agent_l1_api_role" {
  name               = "agent-l1-api-newborn-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "agent_l1_api_basic" {
  name   = "BasicExecution"
  role   = aws_iam_role.agent_l1_api_role.name
  policy = data.aws_iam_policy_document.lambda_basic_execution.json
}

resource "aws_iam_role_policy" "agent_l1_api_dynamodb" {
  name = "DynamoDBAccess"
  role = aws_iam_role.agent_l1_api_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
        ]
        Resource = [
          aws_dynamodb_table.l1_events.arn,
          "${aws_dynamodb_table.l1_events.arn}/index/*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "agent_l1_api_secrets" {
  name = "SecretsManagerAccess"
  role = aws_iam_role.agent_l1_api_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.cf_api_secret.arn]
      }
    ]
  })
}
