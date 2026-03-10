# =============================================================================
# AWS WAF v2 — Layer 6: API Gateway Protection
# =============================================================================

resource "aws_wafv2_web_acl" "agent_api" {
  name        = "tuun-agent-api-waf-newborn"
  description = "WAF for TUUNapp-Agent-API-newborn"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule 1: Rate Limiting (クライアントIP 300req/5min)
  # CF Worker経由のためAPI GWに到達するIPはCloudflare共有IPプール。
  # FORWARDED_IP で CF Worker が付与する X-Forwarded-For のクライアントIPを使用。
  rule {
    name     = "RateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 300
        aggregate_key_type = "FORWARDED_IP"

        forwarded_ip_config {
          header_name       = "X-Forwarded-For"
          fallback_behavior = "MATCH"
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "tuun-agent-rate-limit"
    }
  }

  # Rule 2: AWS Common Rule Set (OWASP Top 10)
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        # SizeRestrictions_BODY: デフォルト8KB制限
        # agent-chat-init は prepare-context のデータ（HealthKit集計等）を
        # 含むため最大数十KBになりうる。Count モードで監視のみ。
        # 実コード安定後にサイズ上限を再評価し、必要に応じて Block に切り替える。
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "tuun-agent-common-rules"
    }
  }

  # Rule 3: Known Bad Inputs (Log4j, SSRF etc)
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"

        # Host ヘッダーインジェクション検知ルール。
        # CF Worker がプロキシ時に Host を API GW に書き換えるため、
        # オリジナルの Host と一致せず誤検知する。Count で監視のみ。
        rule_action_override {
          name = "Host_localhost_HEADER"
          action_to_use {
            count {}
          }
        }

        # Authorization ヘッダー検証ルール。
        # Cognito JWT Bearer トークンを AWS SigV4 として解析しようとし、
        # "Invalid key=value pair (missing equal-sign)" で誤検知する。
        # 認証は Cognito Authorizer + CF Worker JWT 検証で二重に保護済み。
        rule_action_override {
          name = "InvalidAuthorizationHeader"
          action_to_use {
            count {}
          }
        }
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "tuun-agent-bad-inputs"
    }
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "tuun-agent-api-waf"
  }
}

# WAF ↔ API Gateway Stage 関連付け
resource "aws_wafv2_web_acl_association" "agent_api" {
  resource_arn = aws_api_gateway_stage.agent_api_prod.arn
  web_acl_arn  = aws_wafv2_web_acl.agent_api.arn
}
