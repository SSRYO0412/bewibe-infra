# =============================================================================
# IAM Roles and Policies
# =============================================================================
# TUUN アプリケーションで使用する IAM ロール・ポリシー
#
# Phase 2-3 で terraform import を実行
# =============================================================================

# TODO: Phase 2-3 で import 後にコメント解除
#
# 棚卸しで既存の IAM ロール名を確認後、import コマンドを追加
# terraform import aws_iam_role.lambda_execution <role_name>
# terraform import aws_iam_policy.lambda_dynamodb <policy_arn>

# =============================================================================
# Lambda Execution Role
# =============================================================================

# resource "aws_iam_role" "lambda_execution" {
#   name = "tuun-lambda-execution-role"  # 棚卸しで確認後に設定
#
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       }
#     ]
#   })
#
#   tags = {
#     Name        = "Lambda Execution Role"
#     Description = "TUUN Lambda 関数の実行ロール"
#   }
# }

# =============================================================================
# Lambda Basic Execution Policy (CloudWatch Logs)
# =============================================================================

# resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
#   role       = aws_iam_role.lambda_execution.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# =============================================================================
# Custom Policies
# =============================================================================

# resource "aws_iam_policy" "lambda_dynamodb" {
#   name        = "tuun-lambda-dynamodb-policy"
#   description = "Lambda から DynamoDB へのアクセス許可"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "dynamodb:GetItem",
#           "dynamodb:PutItem",
#           "dynamodb:UpdateItem",
#           "dynamodb:DeleteItem",
#           "dynamodb:Query",
#           "dynamodb:Scan"
#         ]
#         Resource = [
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/Users",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/Users/*",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/blood-results",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/blood-results/*",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/gene-analysis-results",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/gene-analysis-results/*",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/user-health-profile",
#           "arn:aws:dynamodb:${var.aws_region}:${var.aws_account_id}:table/user-health-profile/*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "lambda_s3" {
#   name        = "tuun-lambda-s3-policy"
#   description = "Lambda から S3 へのアクセス許可"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket"
#         ]
#         Resource = [
#           "arn:aws:s3:::tuunapp-gene-data-a7x9k3",
#           "arn:aws:s3:::tuunapp-gene-data-a7x9k3/*"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "lambda_cognito" {
#   name        = "tuun-lambda-cognito-policy"
#   description = "Lambda から Cognito へのアクセス許可"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "cognito-idp:AdminCreateUser",
#           "cognito-idp:AdminGetUser",
#           "cognito-idp:AdminUpdateUserAttributes"
#         ]
#         Resource = [
#           "arn:aws:cognito-idp:${var.aws_region}:${var.aws_account_id}:userpool/${var.cognito_user_pool_id}"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "lambda_secrets" {
#   name        = "tuun-lambda-secrets-policy"
#   description = "Lambda から Secrets Manager へのアクセス許可"
#
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "secretsmanager:GetSecretValue"
#         ]
#         Resource = [
#           "arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:tuunapp/*"
#         ]
#       }
#     ]
#   })
# }

# =============================================================================
# Policy Attachments
# =============================================================================

# resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
#   role       = aws_iam_role.lambda_execution.name
#   policy_arn = aws_iam_policy.lambda_dynamodb.arn
# }

# resource "aws_iam_role_policy_attachment" "lambda_s3" {
#   role       = aws_iam_role.lambda_execution.name
#   policy_arn = aws_iam_policy.lambda_s3.arn
# }

# resource "aws_iam_role_policy_attachment" "lambda_cognito" {
#   role       = aws_iam_role.lambda_execution.name
#   policy_arn = aws_iam_policy.lambda_cognito.arn
# }

# resource "aws_iam_role_policy_attachment" "lambda_secrets" {
#   role       = aws_iam_role.lambda_execution.name
#   policy_arn = aws_iam_policy.lambda_secrets.arn
# }
