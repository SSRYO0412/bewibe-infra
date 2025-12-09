# =============================================================================
# Lambda Functions
# =============================================================================
# TUUN アプリケーションで使用する Lambda 関数 (11個)
#
# 注意: Lambda コードは別途管理（CI/CDまたは手動デプロイ）
# Terraform は設定のみ管理し、コード変更は ignore_changes で無視
#
# Phase 2-4 で terraform import を実行
# =============================================================================

# -----------------------------------------------------------------------------
# CreateUserFunctionPython
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.create_user CreateUserFunctionPython

resource "aws_lambda_function" "create_user" {
  function_name = "CreateUserFunctionPython"
  role          = data.aws_iam_role.create_user.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"
  timeout       = 15
  memory_size   = 128

  # プレースホルダー（実際のコードはCI/CDまたは手動デプロイ）
  filename = "${path.module}/files/lambda_placeholder.zip"

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
# BulkRegisterUsersFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.bulk_register BulkRegisterUsersFunction

resource "aws_lambda_function" "bulk_register" {
  function_name = "BulkRegisterUsersFunction"
  role          = data.aws_iam_role.bulk_register.arn
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
# chat-api-function
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.chat_api chat-api-function

resource "aws_lambda_function" "chat_api" {
  function_name = "chat-api-function"
  role          = data.aws_iam_role.chat_api.arn
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
# HealthProfileFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.health_profile HealthProfileFunction

resource "aws_lambda_function" "health_profile" {
  function_name = "HealthProfileFunction"
  role          = data.aws_iam_role.health_profile.arn
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
# GetGeneDataFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.get_gene_data GetGeneDataFunction

resource "aws_lambda_function" "get_gene_data" {
  function_name = "GetGeneDataFunction"
  role          = data.aws_iam_role.get_gene_data.arn
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
# GetGeneRawdataFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.get_gene_rawdata GetGeneRawdataFunction

resource "aws_lambda_function" "get_gene_rawdata" {
  function_name = "GetGeneRawdataFunction"
  role          = data.aws_iam_role.get_gene_rawdata.arn
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
      environment,  # 認証情報が含まれる
    ]
  }
}

# -----------------------------------------------------------------------------
# GetBloodDataFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.get_blood_data GetBloodDataFunction

resource "aws_lambda_function" "get_blood_data" {
  function_name = "GetBloodDataFunction"
  role          = data.aws_iam_role.get_blood_data.arn
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
# blood-analysis-function
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.blood_analysis blood-analysis-function

resource "aws_lambda_function" "blood_analysis" {
  function_name = "blood-analysis-function"
  role          = data.aws_iam_role.blood_analysis.arn
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
# gene-analysis-evidence-function
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.gene_analysis_evidence gene-analysis-evidence-function

resource "aws_lambda_function" "gene_analysis_evidence" {
  function_name = "gene-analysis-evidence-function"
  role          = data.aws_iam_role.gene_analysis_evidence.arn
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
# ConvertGeneTextToJsonFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.convert_gene_text ConvertGeneTextToJsonFunction

resource "aws_lambda_function" "convert_gene_text" {
  function_name = "ConvertGeneTextToJsonFunction"
  role          = data.aws_iam_role.convert_gene_text.arn
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
# PrepareGeneDataTransferFunction
# -----------------------------------------------------------------------------
# Import: terraform import aws_lambda_function.prepare_gene_transfer PrepareGeneDataTransferFunction

resource "aws_lambda_function" "prepare_gene_transfer" {
  function_name = "PrepareGeneDataTransferFunction"
  role          = data.aws_iam_role.prepare_gene_transfer.arn
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
