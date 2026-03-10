# =============================================================================
# EventBridge Rules
# =============================================================================
# TUUN Newborn アプリケーションで使用する EventBridge スケジュール (2個)
#
# - tuun-intelligence-push-schedule-newborn: 2時間ごとのプッシュ通知チェック
# - tuun-agent-scheduled-jobs-newborn: 2時間ごとのスケジュールジョブ実行
# =============================================================================

# -----------------------------------------------------------------------------
# tuun-intelligence-push-schedule-newborn
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "intelligence_push" {
  name                = "tuun-intelligence-push-schedule-newborn"
  description         = "Trigger push notification check every 2 hours (newborn)"
  schedule_expression = "rate(2 hours)"
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "intelligence_push" {
  rule = aws_cloudwatch_event_rule.intelligence_push.name
  arn  = aws_lambda_function.intelligence_push.arn

  target_id = "intelligence-push-function-newborn"
}

# EventBridge が Lambda を呼び出すための権限

resource "aws_lambda_permission" "eventbridge_push" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.intelligence_push.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.intelligence_push.arn
}

# -----------------------------------------------------------------------------
# tuun-agent-scheduled-jobs-newborn (Agent Architecture v8)
# -----------------------------------------------------------------------------

resource "aws_cloudwatch_event_rule" "agent_scheduled_jobs" {
  name                = "tuun-agent-scheduled-jobs-newborn"
  description         = "Trigger scheduled LLM job execution every 2 hours (newborn)"
  schedule_expression = "rate(2 hours)"
  state               = "ENABLED"
}

resource "aws_cloudwatch_event_target" "agent_scheduled_jobs" {
  rule = aws_cloudwatch_event_rule.agent_scheduled_jobs.name
  arn  = aws_lambda_function.scheduled_executor.arn

  target_id = "scheduled-executor-newborn"
}

# EventBridge が Lambda を呼び出すための権限

resource "aws_lambda_permission" "eventbridge_scheduled_executor" {
  statement_id  = "AllowEventBridgeInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.scheduled_executor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.agent_scheduled_jobs.arn
}
