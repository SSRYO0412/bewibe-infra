# =============================================================================
# API Gateway Agent Routes + Cognito Authorizer — Phase 2
# =============================================================================
# TUUNapp-Agent-API-newborn のルート定義、Lambda 統合、認証設定
#
# リソースツリー:
# /
# ├── agent
# │   ├── chat          → POST (agent_chat_init)
# │   │   ├── events    → GET  (agent_chat_events)
# │   │   └── history   → GET, DELETE (agent_chat_history)
# │   │       └── sync  → POST (agent_chat_history)
# │   ├── context       → POST (agent_prepare_context)
# │   ├── prepare-context → POST (agent_prepare_context) — iOS alias
# │   ├── gene          → GET  (agent_gene_data)
# │   ├── blood         → GET  (agent_blood_data)
# │   ├── profile       → GET, POST (agent_health_profile_api)
# │   ├── healthkit     → POST, GET (agent_healthkit_sync)
# │   │   ├── sync      → POST (agent_healthkit_sync)
# │   │   └── status    → GET  (agent_healthkit_sync)
# │   ├── memory        → POST, GET (agent_memory_api)
# │   ├── scores        → GET  (agent_score_engine)
# │   │   ├── calculate → POST (agent_score_engine)
# │   │   └── history   → GET  (agent_score_engine)
# │   ├── settings      → GET, PUT (agent_sync)
# │   ├── sync          → POST, GET (agent_sync)
# │   │   └── full      → GET  (agent_sync)
# │   ├── sync-plan     → POST (agent_usage) — legacy path
# │   └── usage         → GET  (agent_usage)
# │       └── sync-plan → POST (agent_usage) — iOS path
# ├── account
# │   └── delete        → POST (account_delete_handler)
# └── webhooks
#     └── subscription  → POST (subscription_webhook) — 認証なし
# =============================================================================

# =============================================================================
# Layer 7: Cognito Authorizer
# =============================================================================

resource "aws_api_gateway_authorizer" "agent_cognito" {
  name            = "agent-cognito-authorizer-newborn"
  rest_api_id     = aws_api_gateway_rest_api.agent_api.id
  type            = "COGNITO_USER_POOLS"
  provider_arns   = [module.cognito.user_pool_arn]
  identity_source = "method.request.header.Authorization"
}

# =============================================================================
# API Gateway Resources (22 paths)
# =============================================================================

# --- /agent ---
resource "aws_api_gateway_resource" "agent" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_rest_api.agent_api.root_resource_id
  path_part   = "agent"
}

# --- /agent/chat ---
resource "aws_api_gateway_resource" "agent_chat" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "chat"
}

# --- /agent/chat/events ---
resource "aws_api_gateway_resource" "agent_chat_events" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_chat.id
  path_part   = "events"
}

# --- /agent/chat/history ---
resource "aws_api_gateway_resource" "agent_chat_history" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_chat.id
  path_part   = "history"
}

# --- /agent/chat/history/sync ---
resource "aws_api_gateway_resource" "agent_chat_history_sync" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_chat_history.id
  path_part   = "sync"
}

# --- /agent/context ---
resource "aws_api_gateway_resource" "agent_context" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "context"
}

# --- /agent/prepare-context (iOS path alias) ---
resource "aws_api_gateway_resource" "agent_prepare_context" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "prepare-context"
}

# --- /agent/memory ---
resource "aws_api_gateway_resource" "agent_memory" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "memory"
}

# --- /agent/sync ---
resource "aws_api_gateway_resource" "agent_sync" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "sync"
}

# --- /agent/sync/full ---
resource "aws_api_gateway_resource" "agent_sync_full" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_sync.id
  path_part   = "full"
}

# --- /agent/sync-plan ---
resource "aws_api_gateway_resource" "agent_sync_plan" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "sync-plan"
}

# --- /agent/usage ---
resource "aws_api_gateway_resource" "agent_usage" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "usage"
}

# --- /agent/usage/sync-plan (iOS path) ---
resource "aws_api_gateway_resource" "agent_usage_sync_plan" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_usage.id
  path_part   = "sync-plan"
}

# --- /agent/l1 ---
resource "aws_api_gateway_resource" "agent_l1" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "l1"
}

# --- /agent/l1/trigger ---
resource "aws_api_gateway_resource" "agent_l1_trigger" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_l1.id
  path_part   = "trigger"
}

# --- /agent/l1/status ---
resource "aws_api_gateway_resource" "agent_l1_status" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_l1.id
  path_part   = "status"
}

# --- /agent/device-token ---
resource "aws_api_gateway_resource" "agent_device_token" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "device-token"
}

# --- /agent/gene ---
resource "aws_api_gateway_resource" "agent_gene" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "gene"
}

# --- /agent/blood ---
resource "aws_api_gateway_resource" "agent_blood" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "blood"
}

# --- /agent/profile ---
resource "aws_api_gateway_resource" "agent_profile" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "profile"
}

# --- /agent/healthkit ---
resource "aws_api_gateway_resource" "agent_healthkit" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "healthkit"
}

# --- /agent/healthkit/sync ---
resource "aws_api_gateway_resource" "agent_healthkit_sync" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_healthkit.id
  path_part   = "sync"
}

# --- /agent/healthkit/status ---
resource "aws_api_gateway_resource" "agent_healthkit_status" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_healthkit.id
  path_part   = "status"
}

# --- /agent/settings ---
resource "aws_api_gateway_resource" "agent_settings" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "settings"
}

# --- /agent/scores ---
resource "aws_api_gateway_resource" "agent_scores" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "scores"
}

# --- /agent/scores/calculate ---
resource "aws_api_gateway_resource" "agent_scores_calculate" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_scores.id
  path_part   = "calculate"
}

# --- /agent/scores/history ---
resource "aws_api_gateway_resource" "agent_scores_history" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_scores.id
  path_part   = "history"
}

# --- /account ---
resource "aws_api_gateway_resource" "account" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_rest_api.agent_api.root_resource_id
  path_part   = "account"
}

# --- /account/delete ---
resource "aws_api_gateway_resource" "account_delete" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "delete"
}

# --- /webhooks ---
resource "aws_api_gateway_resource" "webhooks" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_rest_api.agent_api.root_resource_id
  path_part   = "webhooks"
}

# --- /webhooks/subscription ---
resource "aws_api_gateway_resource" "webhooks_subscription" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.webhooks.id
  path_part   = "subscription"
}

# =============================================================================
# Methods + Integrations (15 endpoints)
# =============================================================================

# -----------------------------------------------------------------------------
# 1. POST /agent/chat → agent_chat_init
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_chat_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_chat.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_chat_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_chat.id
  http_method             = aws_api_gateway_method.agent_chat_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_chat_init.invoke_arn
}

# -----------------------------------------------------------------------------
# 2. GET /agent/chat/events → agent_chat_events
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_chat_events_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_chat_events.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_chat_events_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_chat_events.id
  http_method             = aws_api_gateway_method.agent_chat_events_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_chat_events.invoke_arn
}

# -----------------------------------------------------------------------------
# 3. GET /agent/chat/history → agent_chat_history
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_chat_history_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_chat_history.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_chat_history_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_chat_history.id
  http_method             = aws_api_gateway_method.agent_chat_history_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_chat_history.invoke_arn
}

# -----------------------------------------------------------------------------
# 4. DELETE /agent/chat/history → agent_chat_history
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_chat_history_delete" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_chat_history.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_chat_history_delete" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_chat_history.id
  http_method             = aws_api_gateway_method.agent_chat_history_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_chat_history.invoke_arn
}

# -----------------------------------------------------------------------------
# 5. POST /agent/chat/history/sync → agent_chat_history
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_chat_history_sync_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_chat_history_sync.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_chat_history_sync_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_chat_history_sync.id
  http_method             = aws_api_gateway_method.agent_chat_history_sync_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_chat_history.invoke_arn
}

# -----------------------------------------------------------------------------
# 6. POST /agent/context → agent_prepare_context
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_context_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_context.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_context_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_context.id
  http_method             = aws_api_gateway_method.agent_context_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_prepare_context.invoke_arn
}

# -----------------------------------------------------------------------------
# 6a. POST /agent/prepare-context → agent_prepare_context (iOS path alias)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_prepare_context_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_prepare_context.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_prepare_context_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_prepare_context.id
  http_method             = aws_api_gateway_method.agent_prepare_context_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_prepare_context.invoke_arn
}

# -----------------------------------------------------------------------------
# 7. POST /agent/memory → agent_memory_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_memory_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_memory.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_memory_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_memory.id
  http_method             = aws_api_gateway_method.agent_memory_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_memory_api.invoke_arn
}

# -----------------------------------------------------------------------------
# 8. GET /agent/memory → agent_memory_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_memory_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_memory.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_memory_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_memory.id
  http_method             = aws_api_gateway_method.agent_memory_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_memory_api.invoke_arn
}

# -----------------------------------------------------------------------------
# 9. POST /agent/sync → agent_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_sync_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_sync.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_sync_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_sync.id
  http_method             = aws_api_gateway_method.agent_sync_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 10. GET /agent/sync → agent_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_sync_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_sync.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_sync_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_sync.id
  http_method             = aws_api_gateway_method.agent_sync_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 11. GET /agent/sync/full → agent_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_sync_full_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_sync_full.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_sync_full_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_sync_full.id
  http_method             = aws_api_gateway_method.agent_sync_full_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 12. POST /agent/sync-plan → agent_usage
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_sync_plan_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_sync_plan.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_sync_plan_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_sync_plan.id
  http_method             = aws_api_gateway_method.agent_sync_plan_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_usage.invoke_arn
}

# -----------------------------------------------------------------------------
# 12a. POST /agent/usage/sync-plan → agent_usage (iOS path)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_usage_sync_plan_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_usage_sync_plan.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_usage_sync_plan_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_usage_sync_plan.id
  http_method             = aws_api_gateway_method.agent_usage_sync_plan_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_usage.invoke_arn
}

# -----------------------------------------------------------------------------
# 13. GET /agent/usage → agent_usage
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_usage_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_usage.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_usage_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_usage.id
  http_method             = aws_api_gateway_method.agent_usage_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_usage.invoke_arn
}

# -----------------------------------------------------------------------------
# 14. POST /account/delete → account_delete_handler
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "account_delete_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.account_delete.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "account_delete_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.account_delete.id
  http_method             = aws_api_gateway_method.account_delete_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.account_delete_handler.invoke_arn
}

# -----------------------------------------------------------------------------
# 15. POST /webhooks/subscription → subscription_webhook (認証なし)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "webhooks_subscription_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.webhooks_subscription.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "webhooks_subscription_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.webhooks_subscription.id
  http_method             = aws_api_gateway_method.webhooks_subscription_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.subscription_webhook.invoke_arn
}

# -----------------------------------------------------------------------------
# 16. POST /agent/device-token → device_token
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_device_token_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_device_token.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_device_token_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_device_token.id
  http_method             = aws_api_gateway_method.agent_device_token_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.device_token.invoke_arn
}

# -----------------------------------------------------------------------------
# 17. DELETE /agent/device-token → device_token
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_device_token_delete" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_device_token.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_device_token_delete" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_device_token.id
  http_method             = aws_api_gateway_method.agent_device_token_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.device_token.invoke_arn
}

# -----------------------------------------------------------------------------
# 18. POST /agent/l1/trigger → agent_l1_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_l1_trigger_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_l1_trigger.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_l1_trigger_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_l1_trigger.id
  http_method             = aws_api_gateway_method.agent_l1_trigger_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_l1_api.invoke_arn
}

# -----------------------------------------------------------------------------
# 19. GET /agent/l1/status → agent_l1_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_l1_status_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_l1_status.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_l1_status_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_l1_status.id
  http_method             = aws_api_gateway_method.agent_l1_status_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_l1_api.invoke_arn
}

# =============================================================================
# DataView Phase 2-4 Methods + Integrations (7 endpoints)
# =============================================================================

# -----------------------------------------------------------------------------
# 16. GET /agent/gene → agent_gene_data
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_gene_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_gene.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_gene_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_gene.id
  http_method             = aws_api_gateway_method.agent_gene_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_gene_data.invoke_arn
}

# -----------------------------------------------------------------------------
# 17. GET /agent/blood → agent_blood_data
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_blood_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_blood.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_blood_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_blood.id
  http_method             = aws_api_gateway_method.agent_blood_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_blood_data.invoke_arn
}

# -----------------------------------------------------------------------------
# 17b. POST /agent/blood → agent_blood_data (血液データ投入)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_blood_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_blood.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_blood_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_blood.id
  http_method             = aws_api_gateway_method.agent_blood_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_blood_data.invoke_arn
}

# -----------------------------------------------------------------------------
# 18. GET /agent/profile → agent_health_profile_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_profile_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_profile.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_profile_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_profile.id
  http_method             = aws_api_gateway_method.agent_profile_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_health_profile_api.invoke_arn
}

# -----------------------------------------------------------------------------
# 19. POST /agent/profile → agent_health_profile_api
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_profile_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_profile.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_profile_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_profile.id
  http_method             = aws_api_gateway_method.agent_profile_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_health_profile_api.invoke_arn
}

# -----------------------------------------------------------------------------
# 20. POST /agent/healthkit → agent_healthkit_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_healthkit_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_healthkit.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_healthkit_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_healthkit.id
  http_method             = aws_api_gateway_method.agent_healthkit_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_healthkit_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20a. POST /agent/healthkit/sync → agent_healthkit_sync (iOS path alias)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_healthkit_sync_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_healthkit_sync.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_healthkit_sync_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_healthkit_sync.id
  http_method             = aws_api_gateway_method.agent_healthkit_sync_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_healthkit_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20b. GET /agent/healthkit/status → agent_healthkit_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_healthkit_status_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_healthkit_status.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_healthkit_status_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_healthkit_status.id
  http_method             = aws_api_gateway_method.agent_healthkit_status_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_healthkit_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20c. GET /agent/settings → agent_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_settings_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_settings.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_settings_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_settings.id
  http_method             = aws_api_gateway_method.agent_settings_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20d. PUT /agent/settings → agent_sync
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_settings_put" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_settings.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_settings_put" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_settings.id
  http_method             = aws_api_gateway_method.agent_settings_put.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20d-2. DELETE /agent/settings → agent_sync (rule deletion)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_settings_delete" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_settings.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_settings_delete" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_settings.id
  http_method             = aws_api_gateway_method.agent_settings_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 20e. GET /agent/healthkit → agent_healthkit_sync (data retrieval)
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_healthkit_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_healthkit.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_healthkit_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_healthkit.id
  http_method             = aws_api_gateway_method.agent_healthkit_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_healthkit_sync.invoke_arn
}

# -----------------------------------------------------------------------------
# 21. GET /agent/scores → agent_score_engine
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_scores_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_scores.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_scores_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_scores.id
  http_method             = aws_api_gateway_method.agent_scores_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_score_engine.invoke_arn
}

# -----------------------------------------------------------------------------
# 22. POST /agent/scores/calculate → agent_score_engine
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_scores_calculate_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_scores_calculate.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_scores_calculate_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_scores_calculate.id
  http_method             = aws_api_gateway_method.agent_scores_calculate_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_score_engine.invoke_arn
}

# -----------------------------------------------------------------------------
# 23. GET /agent/scores/history → agent_score_engine
# -----------------------------------------------------------------------------

resource "aws_api_gateway_method" "agent_scores_history_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_scores_history.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_scores_history_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_scores_history.id
  http_method             = aws_api_gateway_method.agent_scores_history_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_score_engine.invoke_arn
}

# =============================================================================
# Lambda Permissions for API Gateway (9 + 5 = 14 unique Lambda functions)
# =============================================================================

resource "aws_lambda_permission" "apigw_agent_chat_init" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_chat_init.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_chat_events" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_chat_events.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_chat_history" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_chat_history.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_prepare_context" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_prepare_context.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_memory_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_memory_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_sync" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_sync.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_usage" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_usage.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_account_delete_handler" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.account_delete_handler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_subscription_webhook" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.subscription_webhook.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_l1_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_l1_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_device_token" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.device_token.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_gene_data" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_gene_data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_blood_data" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_blood_data.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_health_profile_api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_health_profile_api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_healthkit_sync" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_healthkit_sync.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_agent_score_engine" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_score_engine.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

# =============================================================================
# Deployment + Stage + Throttling
# =============================================================================

resource "aws_api_gateway_deployment" "agent_api" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id

  depends_on = [
    aws_api_gateway_integration.agent_chat_post,
    aws_api_gateway_integration.agent_chat_events_get,
    aws_api_gateway_integration.agent_chat_history_get,
    aws_api_gateway_integration.agent_chat_history_delete,
    aws_api_gateway_integration.agent_chat_history_sync_post,
    aws_api_gateway_integration.agent_context_post,
    aws_api_gateway_integration.agent_prepare_context_post,
    aws_api_gateway_integration.agent_memory_post,
    aws_api_gateway_integration.agent_memory_get,
    aws_api_gateway_integration.agent_sync_post,
    aws_api_gateway_integration.agent_sync_get,
    aws_api_gateway_integration.agent_sync_full_get,
    aws_api_gateway_integration.agent_sync_plan_post,
    aws_api_gateway_integration.agent_usage_sync_plan_post,
    aws_api_gateway_integration.agent_usage_get,
    aws_api_gateway_integration.account_delete_post,
    aws_api_gateway_integration.webhooks_subscription_post,
    aws_api_gateway_integration.agent_device_token_post,
    aws_api_gateway_integration.agent_device_token_delete,
    aws_api_gateway_integration.agent_l1_trigger_post,
    aws_api_gateway_integration.agent_l1_status_get,
    # DataView Phase 2-4
    aws_api_gateway_integration.agent_gene_get,
    aws_api_gateway_integration.agent_blood_get,
    aws_api_gateway_integration.agent_blood_post,
    aws_api_gateway_integration.agent_profile_get,
    aws_api_gateway_integration.agent_profile_post,
    aws_api_gateway_integration.agent_healthkit_post,
    aws_api_gateway_integration.agent_healthkit_sync_post,
    aws_api_gateway_integration.agent_healthkit_status_get,
    aws_api_gateway_integration.agent_settings_get,
    aws_api_gateway_integration.agent_settings_put,
    aws_api_gateway_integration.agent_settings_delete,
    aws_api_gateway_integration.agent_healthkit_get,
    aws_api_gateway_integration.agent_scores_get,
    aws_api_gateway_integration.agent_scores_calculate_post,
    aws_api_gateway_integration.agent_scores_history_get,
    # Agent Summary
    aws_api_gateway_integration.agent_summary_get,
    aws_api_gateway_integration.agent_summary_post,
    # Agent Notification Enrich
    aws_api_gateway_integration.agent_notification_enrich_post,
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.agent_chat_post.id,
      aws_api_gateway_integration.agent_chat_post.id,
      aws_api_gateway_method.agent_chat_events_get.id,
      aws_api_gateway_integration.agent_chat_events_get.id,
      aws_api_gateway_method.agent_chat_history_get.id,
      aws_api_gateway_integration.agent_chat_history_get.id,
      aws_api_gateway_method.agent_chat_history_delete.id,
      aws_api_gateway_integration.agent_chat_history_delete.id,
      aws_api_gateway_method.agent_chat_history_sync_post.id,
      aws_api_gateway_integration.agent_chat_history_sync_post.id,
      aws_api_gateway_method.agent_context_post.id,
      aws_api_gateway_integration.agent_context_post.id,
      aws_api_gateway_method.agent_prepare_context_post.id,
      aws_api_gateway_integration.agent_prepare_context_post.id,
      aws_api_gateway_method.agent_memory_post.id,
      aws_api_gateway_integration.agent_memory_post.id,
      aws_api_gateway_method.agent_memory_get.id,
      aws_api_gateway_integration.agent_memory_get.id,
      aws_api_gateway_method.agent_sync_post.id,
      aws_api_gateway_integration.agent_sync_post.id,
      aws_api_gateway_method.agent_sync_get.id,
      aws_api_gateway_integration.agent_sync_get.id,
      aws_api_gateway_method.agent_sync_full_get.id,
      aws_api_gateway_integration.agent_sync_full_get.id,
      aws_api_gateway_method.agent_sync_plan_post.id,
      aws_api_gateway_integration.agent_sync_plan_post.id,
      aws_api_gateway_method.agent_usage_sync_plan_post.id,
      aws_api_gateway_integration.agent_usage_sync_plan_post.id,
      aws_api_gateway_method.agent_usage_get.id,
      aws_api_gateway_integration.agent_usage_get.id,
      aws_api_gateway_method.account_delete_post.id,
      aws_api_gateway_integration.account_delete_post.id,
      aws_api_gateway_method.webhooks_subscription_post.id,
      aws_api_gateway_integration.webhooks_subscription_post.id,
      aws_api_gateway_method.agent_device_token_post.id,
      aws_api_gateway_integration.agent_device_token_post.id,
      aws_api_gateway_method.agent_device_token_delete.id,
      aws_api_gateway_integration.agent_device_token_delete.id,
      aws_api_gateway_method.agent_l1_trigger_post.id,
      aws_api_gateway_integration.agent_l1_trigger_post.id,
      aws_api_gateway_method.agent_l1_status_get.id,
      aws_api_gateway_integration.agent_l1_status_get.id,
      # DataView Phase 2-4
      aws_api_gateway_method.agent_gene_get.id,
      aws_api_gateway_integration.agent_gene_get.id,
      aws_api_gateway_method.agent_blood_get.id,
      aws_api_gateway_integration.agent_blood_get.id,
      aws_api_gateway_method.agent_blood_post.id,
      aws_api_gateway_integration.agent_blood_post.id,
      aws_api_gateway_method.agent_profile_get.id,
      aws_api_gateway_integration.agent_profile_get.id,
      aws_api_gateway_method.agent_profile_post.id,
      aws_api_gateway_integration.agent_profile_post.id,
      aws_api_gateway_method.agent_healthkit_post.id,
      aws_api_gateway_integration.agent_healthkit_post.id,
      aws_api_gateway_method.agent_healthkit_sync_post.id,
      aws_api_gateway_integration.agent_healthkit_sync_post.id,
      aws_api_gateway_method.agent_healthkit_status_get.id,
      aws_api_gateway_integration.agent_healthkit_status_get.id,
      aws_api_gateway_method.agent_settings_get.id,
      aws_api_gateway_integration.agent_settings_get.id,
      aws_api_gateway_method.agent_settings_put.id,
      aws_api_gateway_integration.agent_settings_put.id,
      aws_api_gateway_method.agent_settings_delete.id,
      aws_api_gateway_integration.agent_settings_delete.id,
      aws_api_gateway_method.agent_healthkit_get.id,
      aws_api_gateway_integration.agent_healthkit_get.id,
      aws_api_gateway_method.agent_scores_get.id,
      aws_api_gateway_integration.agent_scores_get.id,
      aws_api_gateway_method.agent_scores_calculate_post.id,
      aws_api_gateway_integration.agent_scores_calculate_post.id,
      aws_api_gateway_method.agent_scores_history_get.id,
      aws_api_gateway_integration.agent_scores_history_get.id,
      # Agent Summary
      aws_api_gateway_method.agent_summary_get.id,
      aws_api_gateway_integration.agent_summary_get.id,
      aws_api_gateway_method.agent_summary_post.id,
      aws_api_gateway_integration.agent_summary_post.id,
      # Agent Notification Enrich
      aws_api_gateway_method.agent_notification_enrich_post.id,
      aws_api_gateway_integration.agent_notification_enrich_post.id,
      aws_api_gateway_rest_api_policy.agent_api.policy,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "agent_api_prod" {
  deployment_id = aws_api_gateway_deployment.agent_api.id
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  stage_name    = "prod"
}

# =============================================================================
# Agent Summary Routes (GET, POST /agent/summary)
# =============================================================================

# --- /agent/summary ---
resource "aws_api_gateway_resource" "agent_summary" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "summary"
}

# GET /agent/summary → agent_summary
resource "aws_api_gateway_method" "agent_summary_get" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_summary.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_summary_get" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_summary.id
  http_method             = aws_api_gateway_method.agent_summary_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_summary.invoke_arn
}

# POST /agent/summary → agent_summary (force regenerate)
resource "aws_api_gateway_method" "agent_summary_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_summary.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_summary_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_summary.id
  http_method             = aws_api_gateway_method.agent_summary_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_summary.invoke_arn
}

# Lambda permission for API Gateway → agent_summary
resource "aws_lambda_permission" "apigw_agent_summary" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_summary.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

# =============================================================================
# Agent Notification Enrich Routes (POST /agent/notification/enrich)
# =============================================================================

# --- /agent/notification ---
resource "aws_api_gateway_resource" "agent_notification" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent.id
  path_part   = "notification"
}

# --- /agent/notification/enrich ---
resource "aws_api_gateway_resource" "agent_notification_enrich" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  parent_id   = aws_api_gateway_resource.agent_notification.id
  path_part   = "enrich"
}

# POST /agent/notification/enrich → agent_notification_enrich
resource "aws_api_gateway_method" "agent_notification_enrich_post" {
  rest_api_id   = aws_api_gateway_rest_api.agent_api.id
  resource_id   = aws_api_gateway_resource.agent_notification_enrich.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.agent_cognito.id
}

resource "aws_api_gateway_integration" "agent_notification_enrich_post" {
  rest_api_id             = aws_api_gateway_rest_api.agent_api.id
  resource_id             = aws_api_gateway_resource.agent_notification_enrich.id
  http_method             = aws_api_gateway_method.agent_notification_enrich_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.agent_notification_enrich.invoke_arn
}

# Lambda permission for API Gateway → agent_notification_enrich
resource "aws_lambda_permission" "apigw_agent_notification_enrich" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.agent_notification_enrich.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.agent_api.execution_arn}/*/*"
}

# Stage-level throttling + CloudWatch metrics
resource "aws_api_gateway_method_settings" "agent_api_settings" {
  rest_api_id = aws_api_gateway_rest_api.agent_api.id
  stage_name  = aws_api_gateway_stage.agent_api_prod.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = 50
    throttling_rate_limit  = 100
    metrics_enabled        = true
  }
}
