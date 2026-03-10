# =============================================================================
# Lambda Functions
# =============================================================================
# TUUN Newborn アプリケーションで使用する Lambda 関数 (34個)
#
# 注意: Lambda コードは別途管理（CI/CDまたは手動デプロイ）
# Terraform は設定のみ管理し、コード変更は ignore_changes で無視
# =============================================================================

# -----------------------------------------------------------------------------
# CreateUserFunctionPython-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "create_user" {
  function_name = "CreateUserFunctionPython-newborn"
  role          = aws_iam_role.create_user.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 128

  # プレースホルダー（実際のコードはCI/CDまたは手動デプロイ）
  filename = "${path.module}/files/lambda_placeholder.zip"

  environment {
    variables = {
      S3_BUCKET   = aws_s3_bucket.gene_data.bucket
      USERS_TABLE = aws_dynamodb_table.users.name
    }
  }

  # コードは Terraform 管理外（CI/CD または手動デプロイ）
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# BulkRegisterUsersFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "bulk_register" {
  function_name = "BulkRegisterUsersFunction-newborn"
  role          = aws_iam_role.bulk_register.arn
  handler       = "bulk_register_lambda.lambda_handler"
  runtime       = "python3.13"
  timeout       = 300
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# chat-api-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "chat_api" {
  function_name = "chat-api-function-newborn"
  role          = aws_iam_role.chat_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 60
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# HealthProfileFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "health_profile" {
  function_name = "HealthProfileFunction-newborn"
  role          = aws_iam_role.health_profile.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# GetGeneDataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "get_gene_data" {
  function_name = "GetGeneDataFunction-newborn"
  role          = aws_iam_role.get_gene_data.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# GetGeneRawdataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "get_gene_rawdata" {
  function_name = "GetGeneRawdataFunction-newborn"
  role          = aws_iam_role.get_gene_rawdata.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  # VPC設定（既存の外部API接続用）
  vpc_config {
    subnet_ids         = ["subnet-0c7845dde99db2175"]
    security_group_ids = ["sg-0e2169da081a2bf0a"]
  }

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment, # 認証情報が含まれる
    ]
  }
}

# -----------------------------------------------------------------------------
# GetBloodDataFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "get_blood_data" {
  function_name = "GetBloodDataFunction-newborn"
  role          = aws_iam_role.get_blood_data.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# blood-analysis-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "blood_analysis" {
  function_name = "blood-analysis-function-newborn"
  role          = aws_iam_role.blood_analysis.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# gene-analysis-evidence-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "gene_analysis_evidence" {
  function_name = "gene-analysis-evidence-function-newborn"
  role          = aws_iam_role.gene_analysis_evidence.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 10
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# ConvertGeneTextToJsonFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "convert_gene_text" {
  function_name = "ConvertGeneTextToJsonFunction-newborn"
  role          = aws_iam_role.convert_gene_text.arn
  handler       = "index.handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
    ]
  }
}

# -----------------------------------------------------------------------------
# PrepareGeneDataTransferFunction-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "prepare_gene_transfer" {
  function_name = "PrepareGeneDataTransferFunction-newborn"
  role          = aws_iam_role.prepare_gene_transfer.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 3
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# =============================================================================
# Intelligence / Claude 系 Lambda 関数 (7個)
# =============================================================================

# -----------------------------------------------------------------------------
# intelligence-api-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "intelligence_api" {
  function_name = "intelligence-api-function-newborn"
  role          = aws_iam_role.intelligence_api.arn
  handler       = "intelligence_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 30
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# intelligence-api-claude-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "intelligence_api_claude" {
  function_name = "intelligence-api-claude-newborn"
  role          = aws_iam_role.intelligence_api.arn
  handler       = "intelligence_claude_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 180
  memory_size   = 512

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# chat-api-claude-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "chat_api_claude" {
  function_name = "chat-api-claude-newborn"
  role          = aws_iam_role.intelligence_api.arn
  handler       = "chat_claude_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 120
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# intelligence-push-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "intelligence_push" {
  function_name = "intelligence-push-function-newborn"
  role          = aws_iam_role.intelligence_push.arn
  handler       = "push_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 300
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# device-token-registration-function-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "device_token" {
  function_name = "device-token-registration-function-newborn"
  role          = aws_iam_role.device_token.arn
  handler       = "device_token_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 10
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# tuun-eval-pipeline-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "eval_pipeline" {
  function_name = "tuun-eval-pipeline-newborn"
  role          = aws_iam_role.intelligence_api.arn
  handler       = "lambda_eval_pipeline.lambda_handler"
  runtime       = "python3.13"
  timeout       = 900
  memory_size   = 512

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# tuun-eval-self-repair-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "eval_self_repair" {
  function_name = "tuun-eval-self-repair-newborn"
  role          = aws_iam_role.intelligence_api.arn
  handler       = "lambda_eval_self_repair.lambda_handler"
  runtime       = "python3.13"
  timeout       = 300
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# =============================================================================
# Agent Architecture v8 - Lambda Functions (11個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# agent-chat-init-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_chat_init" {
  function_name = "agent-chat-init-newborn"
  description   = "Agent chat session initializer - returns jobId for async processing"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-chat-processor-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_chat_processor" {
  function_name = "agent-chat-processor-newborn"
  description   = "Async LLM processor with Tool Use - graceful exit at remaining 60s"
  role          = aws_iam_role.agent_processor.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 300
  memory_size   = 512

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-chat-events-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_chat_events" {
  function_name = "agent-chat-events-newborn"
  description   = "SSE event polling endpoint for chat streaming"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 5
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-prepare-context-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_prepare_context" {
  function_name = "agent-prepare-context-newborn"
  description   = "Data summary generator for LLM context preparation"
  role          = aws_iam_role.agent_prepare_context.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-memory-api-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_memory_api" {
  function_name = "agent-memory-api-newborn"
  description   = "Agent memory save/load/search API"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-sync-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_sync" {
  function_name = "agent-sync-newborn"
  description   = "Device settings sync (push/pull/full restore)"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-chat-history-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_chat_history" {
  function_name = "agent-chat-history-newborn"
  description   = "Chat history management (list/delete sessions)"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-usage-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_usage" {
  function_name = "agent-usage-newborn"
  description   = "Usage quota check and tracking"
  role          = aws_iam_role.agent_api.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 5
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# account-delete-handler-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "account_delete_handler" {
  function_name = "account-delete-handler-newborn"
  description   = "Full account deletion (DynamoDB + S3 + Cognito cleanup)"
  role          = aws_iam_role.account_delete.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 60
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# scheduled-executor-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "scheduled_executor" {
  function_name = "scheduled-executor-newborn"
  description   = "Scheduled LLM job executor (EventBridge triggered)"
  role          = aws_iam_role.agent_processor.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 300
  memory_size   = 512

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# subscription-webhook-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "subscription_webhook" {
  function_name = "subscription-webhook-newborn"
  description   = "Apple StoreKit Server Notification webhook handler"
  role          = aws_iam_role.subscription_webhook.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 10
  memory_size   = 128

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# =============================================================================
# DataView Phase 2-4 - Lambda Functions (5個追加)
# =============================================================================

# -----------------------------------------------------------------------------
# agent-gene-data-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_gene_data" {
  function_name = "agent-gene-data-newborn"
  description   = "Gene data retrieval API for DataView"
  role          = aws_iam_role.agent_gene_data_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-blood-data-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_blood_data" {
  function_name = "agent-blood-data-newborn"
  description   = "Blood data retrieval API for DataView"
  role          = aws_iam_role.agent_blood_data_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-health-profile-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_health_profile_api" {
  function_name = "agent-health-profile-newborn"
  description   = "Health profile GET/POST API for DataView"
  role          = aws_iam_role.agent_health_profile_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-healthkit-sync-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_healthkit_sync" {
  function_name = "agent-healthkit-sync-newborn"
  description   = "HealthKit data sync API for DataView"
  role          = aws_iam_role.agent_healthkit_sync_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-score-engine-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_score_engine" {
  function_name = "agent-score-engine-newborn"
  description   = "Score calculation and retrieval engine for DataView"
  role          = aws_iam_role.agent_score_engine_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 30
  memory_size   = 512

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-l1-api-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_l1_api" {
  function_name = "agent-l1-api-newborn"
  description   = "L1 rule trigger event recording and status API"
  role          = aws_iam_role.agent_l1_api_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-summary-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_summary" {
  function_name = "agent-summary-newborn"
  description   = "Agent Summary generation with Claude Haiku + DynamoDB cache"
  role          = aws_iam_role.agent_processor.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 30
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}

# -----------------------------------------------------------------------------
# agent-notification-enrich-newborn
# -----------------------------------------------------------------------------

resource "aws_lambda_function" "agent_notification_enrich" {
  function_name = "agent-notification-enrich-newborn"
  description   = "AI-powered notification card enrichment with Claude Haiku"
  role          = aws_iam_role.agent_processor.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 30
  memory_size   = 256

  filename = "${path.module}/files/lambda_placeholder.zip"

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      layers,
      environment,
    ]
  }
}
