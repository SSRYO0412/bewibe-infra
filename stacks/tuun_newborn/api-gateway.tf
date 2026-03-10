# =============================================================================
# API Gateway (REST API) - Detailed Configuration
# =============================================================================
# TUUN Newborn アプリケーションで使用する API Gateway (6つ)
#
# 新規作成:
# - UserAPI-newborn: サインアップAPI
# - TUUNapp-Chat-API-newborn: AIチャット機能
# - TUUNapp-Health-Profile-API-newborn: ヘルスプロファイル
# - TUUNapp-Get-Gene-API-newborn: 遺伝子データ取得
# - TUUNapp-Get-Blood-API-newborn: 血液検査データ
# - TUUNapp-Gene-Transfer-API-newborn: 遺伝子データ移行
#
# 注意: API Gateway の詳細設定（リソース、メソッド、統合、ステージ）は
# apigateway.tf で REST API 本体を作成後に別途設定する。
# =============================================================================

# TODO: 各 API のリソース/メソッド/統合/ステージ設定を追加

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

# TODO: 各 Lambda への invoke 権限を設定
# resource "aws_lambda_permission" "user_api" {
#   statement_id  = "AllowAPIGatewayInvoke"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.create_user.function_name
#   principal     = "apigateway.amazonaws.com"
#   source_arn    = "${aws_api_gateway_rest_api.user_api.execution_arn}/*/*"
# }
