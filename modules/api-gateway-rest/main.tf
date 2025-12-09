# =============================================================================
# API Gateway REST Module
# =============================================================================
# REST API Gateway を作成する再利用可能モジュール
# =============================================================================

resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = var.api_description

  endpoint_configuration {
    types = var.endpoint_types
  }

  tags = var.tags
}

# ルートリソース配下のリソース作成は呼び出し側で行う
# このモジュールは REST API 本体のみを管理

resource "aws_api_gateway_deployment" "this" {
  count = var.create_deployment ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = var.deployment_trigger
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  count = var.create_stage ? 1 : 0

  deployment_id = aws_api_gateway_deployment.this[0].id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name

  dynamic "access_log_settings" {
    for_each = var.access_log_destination_arn != null ? [1] : []
    content {
      destination_arn = var.access_log_destination_arn
      format          = var.access_log_format
    }
  }

  tags = var.tags
}
