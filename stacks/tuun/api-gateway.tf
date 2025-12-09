# =============================================================================
# API Gateway (REST API)
# =============================================================================
# TUUN アプリケーションで使用する API Gateway (6つ)
#
# 既存 API:
# - UserAPI (02fc5gnwoi): サインアップAPI
# - TUUNapp-Chat-API (kbodeqy5wa): AIチャット機能
# - TUUNapp-Health-Profile-API (70ubpe7e14): ヘルスプロファイル
# - TUUNapp-Get-Gene-API (kxuyul35l4): 遺伝子データ取得
# - TUUNapp-Get-Blood-API (7rk2qibxm6): 血液検査データ
# - TUUNapp-Gene-Transfer-API (1ac2k99n71): 遺伝子データ移行
#
# Phase 2-5 で terraform import を実行
#
# 注意: API Gateway REST API の import は複雑です。
# API 本体、リソース、メソッド、統合、ステージを個別に import する必要があります。
# =============================================================================

# TODO: Phase 2-5 で import 後にコメント解除
#
# 各 API の import コマンド例:
#
# UserAPI:
# terraform import aws_api_gateway_rest_api.user_api 02fc5gnwoi
# terraform import aws_api_gateway_resource.user_api_users 02fc5gnwoi/<resource_id>
# terraform import aws_api_gateway_method.user_api_post 02fc5gnwoi/<resource_id>/POST
# terraform import aws_api_gateway_integration.user_api_post 02fc5gnwoi/<resource_id>/POST
# terraform import aws_api_gateway_deployment.user_api <rest_api_id>/<deployment_id>
# terraform import aws_api_gateway_stage.user_api_prod 02fc5gnwoi/prod

# =============================================================================
# UserAPI
# =============================================================================

# resource "aws_api_gateway_rest_api" "user_api" {
#   name        = "UserAPI"
#   description = "サインアップAPI"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "UserAPI"
#   }
# }

# =============================================================================
# TUUNapp-Chat-API
# =============================================================================

# resource "aws_api_gateway_rest_api" "chat_api" {
#   name        = "TUUNapp-Chat-API"
#   description = "AIチャット機能用API"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "TUUNapp-Chat-API"
#   }
# }

# =============================================================================
# TUUNapp-Health-Profile-API
# =============================================================================

# resource "aws_api_gateway_rest_api" "health_profile_api" {
#   name        = "TUUNapp-Health-Profile-API"
#   description = "ヘルスプロファイルAPI"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "TUUNapp-Health-Profile-API"
#   }
# }

# =============================================================================
# TUUNapp-Get-Gene-API
# =============================================================================

# resource "aws_api_gateway_rest_api" "gene_api" {
#   name        = "TUUNapp-Get-Gene-API"
#   description = "遺伝子データ取得専用API"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "TUUNapp-Get-Gene-API"
#   }
# }

# =============================================================================
# TUUNapp-Get-Blood-API
# =============================================================================

# resource "aws_api_gateway_rest_api" "blood_api" {
#   name        = "TUUNapp-Get-Blood-API"
#   description = "血液検査データ取得専用API"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "TUUNapp-Get-Blood-API"
#   }
# }

# =============================================================================
# TUUNapp-Gene-Transfer-API
# =============================================================================

# resource "aws_api_gateway_rest_api" "gene_transfer_api" {
#   name        = "TUUNapp-Gene-Transfer-API"
#   description = "遺伝子データ移行API"
#
#   endpoint_configuration {
#     types = ["REGIONAL"]
#   }
#
#   tags = {
#     Name = "TUUNapp-Gene-Transfer-API"
#   }
# }

# =============================================================================
# API Gateway Stages
# =============================================================================

# TODO: 各 API のステージ設定
# resource "aws_api_gateway_stage" "user_api_prod" {
#   deployment_id = aws_api_gateway_deployment.user_api.id
#   rest_api_id   = aws_api_gateway_rest_api.user_api.id
#   stage_name    = "prod"
# }

# =============================================================================
# Lambda Permissions for API Gateway
# =============================================================================

# TODO: Phase 2-5 で各 Lambda への invoke 権限を設定
# resource "aws_lambda_permission" "user_api" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.create_user.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/*"
# }
