# =============================================================================
# Lambda Functions
# =============================================================================
# TUUN アプリケーションで使用する Lambda 関数 (11個)
#
# 既存関数:
# - CreateUserFunctionPython: Cognito PostConfirmation
# - BulkRegisterUsersFunction: CSV一括登録
# - chat-api-function: AIチャット
# - HealthProfileFunction: ヘルスプロファイル管理
# - GetGeneDataFunction: 遺伝子データ取得
# - GetGeneRawdataFunction: 遺伝子生データ取得
# - GetBloodDataFunction: 血液データ取得
# - blood-analysis-function: 血液解析
# - gene-analysis-evidence-function: 遺伝子解析エビデンス
# - ConvertGeneTextToJsonFunction: テキスト→JSON変換
# - PrepareGeneDataTransferFunction: データ移行準備
#
# Phase 2-4 で terraform import を実行
# =============================================================================

# TODO: Phase 2-4 で import 後にコメント解除
#
# terraform import aws_lambda_function.create_user CreateUserFunctionPython
# terraform import aws_lambda_function.bulk_register BulkRegisterUsersFunction
# terraform import aws_lambda_function.chat_api chat-api-function
# terraform import aws_lambda_function.health_profile HealthProfileFunction
# terraform import aws_lambda_function.get_gene_data GetGeneDataFunction
# terraform import aws_lambda_function.get_gene_rawdata GetGeneRawdataFunction
# terraform import aws_lambda_function.get_blood_data GetBloodDataFunction
# terraform import aws_lambda_function.blood_analysis blood-analysis-function
# terraform import aws_lambda_function.gene_analysis_evidence gene-analysis-evidence-function
# terraform import aws_lambda_function.convert_gene_text ConvertGeneTextToJsonFunction
# terraform import aws_lambda_function.prepare_gene_transfer PrepareGeneDataTransferFunction

# =============================================================================
# Lambda Deployment Packages
# =============================================================================

# TODO: Phase 2-4 でソースコードを lambda-src/tuun/ に配置後に有効化
#
# data "archive_file" "create_user" {
#   type        = "zip"
#   source_dir  = "${path.module}/../../lambda-src/tuun/cognito-trigger"
#   output_path = "${path.module}/../../lambda-src/tuun/cognito-trigger.zip"
# }

# =============================================================================
# Lambda Functions
# =============================================================================

# resource "aws_lambda_function" "create_user" {
#   function_name = "CreateUserFunctionPython"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   filename         = data.archive_file.create_user.output_path
#   source_code_hash = data.archive_file.create_user.output_base64sha256
#
#   environment {
#     variables = {
#       ENVIRONMENT = var.environment
#       # 棚卸しで確認した環境変数を追加
#     }
#   }
#
#   tags = {
#     Name        = "CreateUserFunctionPython"
#     Description = "Cognito PostConfirmation Lambda"
#   }
# }

# resource "aws_lambda_function" "bulk_register" {
#   function_name = "BulkRegisterUsersFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   # filename と source_code_hash は Phase 2-4 で設定
#
#   tags = {
#     Name        = "BulkRegisterUsersFunction"
#     Description = "CSV一括ユーザー登録"
#   }
# }

# resource "aws_lambda_function" "chat_api" {
#   function_name = "chat-api-function"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = 60  # チャットは時間がかかる可能性
#   memory_size   = 512
#
#   tags = {
#     Name        = "chat-api-function"
#     Description = "AI チャット機能"
#   }
# }

# resource "aws_lambda_function" "health_profile" {
#   function_name = "HealthProfileFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "HealthProfileFunction"
#     Description = "ヘルスプロファイル管理"
#   }
# }

# resource "aws_lambda_function" "get_gene_data" {
#   function_name = "GetGeneDataFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "GetGeneDataFunction"
#     Description = "遺伝子データ取得"
#   }
# }

# resource "aws_lambda_function" "get_gene_rawdata" {
#   function_name = "GetGeneRawdataFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "GetGeneRawdataFunction"
#     Description = "遺伝子生データ取得"
#   }
# }

# resource "aws_lambda_function" "get_blood_data" {
#   function_name = "GetBloodDataFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "GetBloodDataFunction"
#     Description = "血液データ取得"
#   }
# }

# resource "aws_lambda_function" "blood_analysis" {
#   function_name = "blood-analysis-function"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "blood-analysis-function"
#     Description = "血液解析"
#   }
# }

# resource "aws_lambda_function" "gene_analysis_evidence" {
#   function_name = "gene-analysis-evidence-function"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "gene-analysis-evidence-function"
#     Description = "遺伝子解析エビデンス"
#   }
# }

# resource "aws_lambda_function" "convert_gene_text" {
#   function_name = "ConvertGeneTextToJsonFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "ConvertGeneTextToJsonFunction"
#     Description = "遺伝子テキスト→JSON変換"
#   }
# }

# resource "aws_lambda_function" "prepare_gene_transfer" {
#   function_name = "PrepareGeneDataTransferFunction"
#   role          = aws_iam_role.lambda_execution.arn
#   handler       = "lambda_function.lambda_handler"
#   runtime       = var.lambda_runtime
#   timeout       = var.lambda_timeout
#   memory_size   = var.lambda_memory_size
#
#   tags = {
#     Name        = "PrepareGeneDataTransferFunction"
#     Description = "データ移行準備"
#   }
# }

# =============================================================================
# CloudWatch Log Groups
# =============================================================================

# TODO: Phase 2-4 で有効化
# resource "aws_cloudwatch_log_group" "create_user" {
#   name              = "/aws/lambda/CreateUserFunctionPython"
#   retention_in_days = 30
# }
