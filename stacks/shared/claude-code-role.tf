# =============================================================================
# Claude Code 用 IAM ユーザー（v2.1）
# =============================================================================
#
# 設計方針:
# - claude-* プレフィックスのリソースのみ操作可能
# - 既存TUUNリソースへのアクセスは不可
# - Access Key は Terraform 管理外（手動発行）
# - 主な安全性は IAM ポリシーで担保
# - 新規リソース作成（Lambda/DynamoDB/S3）は Terraform 経由に統一
# =============================================================================

locals {
  # Claude用バケット（S3 ARNはワイルドカード不可のため列挙）
  claude_buckets = [
    "claude-sandbox-${data.aws_caller_identity.current.account_id}"
  ]
}

# -----------------------------------------------------------------------------
# IAM ユーザー（Access Key は手動で作成）
# -----------------------------------------------------------------------------

resource "aws_iam_user" "claude_code" {
  name = "claude-code"
  path = "/automation/"

  tags = {
    Purpose   = "Claude Code automation"
    ManagedBy = "Terraform"
  }
}

# -----------------------------------------------------------------------------
# IAM マネージドポリシー（インラインは2KBまでのため）
# -----------------------------------------------------------------------------

resource "aws_iam_policy" "claude_code" {
  name        = "claude-code-policy"
  description = "Policy for Claude Code automation user"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Lambda: claude-* 関数のみ更新可能
      {
        Sid    = "ClaudeLambdaEdit"
        Effect = "Allow"
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:GetFunction",
          "lambda:GetFunctionConfiguration",
          "lambda:InvokeFunction",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:TagResource",
          "lambda:UntagResource"
        ]
        Resource = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:claude-*"
      },
      {
        Sid      = "ClaudeLambdaList"
        Effect   = "Allow"
        Action   = ["lambda:ListFunctions", "lambda:ListTags"]
        Resource = "*"
      },
      # DynamoDB: claude-* テーブルのデータ操作のみ
      {
        Sid    = "ClaudeDynamoData"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DescribeTable"
        ]
        Resource = [
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/claude-*",
          "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/claude-*/index/*"
        ]
      },
      {
        Sid      = "ClaudeDynamoList"
        Effect   = "Allow"
        Action   = ["dynamodb:ListTables"]
        Resource = "*"
      },
      # S3: 指定バケット内のオブジェクト操作のみ
      {
        Sid    = "ClaudeS3Objects"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket", "s3:GetBucketLocation"]
        Resource = concat(
          [for b in local.claude_buckets : "arn:aws:s3:::${b}"],
          [for b in local.claude_buckets : "arn:aws:s3:::${b}/*"]
        )
      },
      {
        Sid      = "ClaudeS3List"
        Effect   = "Allow"
        Action   = ["s3:ListAllMyBuckets"]
        Resource = "*"
      },
      # CloudWatch Logs
      {
        Sid    = "ClaudeLogsRead"
        Effect = "Allow"
        Action = ["logs:DescribeLogGroups", "logs:DescribeLogStreams", "logs:GetLogEvents", "logs:FilterLogEvents"]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/claude-*",
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/claude-*:*"
        ]
      },
      # IAM PassRole
      {
        Sid      = "ClaudePassRole"
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/claude-*"
        Condition = {
          StringEquals = { "iam:PassedToService" = "lambda.amazonaws.com" }
        }
      },
      # Terraform State: 読み取り専用
      {
        Sid      = "TerraformStateRead"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::tuun-terraform-state-${data.aws_caller_identity.current.account_id}",
          "arn:aws:s3:::tuun-terraform-state-${data.aws_caller_identity.current.account_id}/*"
        ]
      },
      {
        Sid      = "TerraformLockRead"
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:DescribeTable"]
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/tuun-terraform-locks"
      },
      # 読み取り専用: 既存リソース確認用
      {
        Sid    = "ReadOnlyForContext"
        Effect = "Allow"
        Action = [
          "cognito-idp:Describe*",
          "cognito-idp:List*",
          "apigateway:GET",
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:DescribeParameters",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:ListRoles",
          "iam:ListPolicies"
        ]
        Resource = "*"
      },
      # 明示的拒否: 危険な操作
      {
        Sid    = "DenyDestructive"
        Effect = "Deny"
        Action = [
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "dynamodb:CreateTable",
          "dynamodb:DeleteTable",
          "dynamodb:UpdateTable",
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:CreateUser",
          "iam:DeleteUser",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "ssm:PutParameter",
          "ssm:DeleteParameter",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:PutSecretValue"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "claude_code" {
  user       = aws_iam_user.claude_code.name
  policy_arn = aws_iam_policy.claude_code.arn
}

# -----------------------------------------------------------------------------
# 注意: Access Key は Terraform では作成しない
# -----------------------------------------------------------------------------
# 発行手順:
# 1. AWS Console > IAM > Users > claude-code > Security credentials
# 2. Create access key
# 3. ~/.aws/credentials に [claude-code] プロファイルとして保存
# -----------------------------------------------------------------------------
