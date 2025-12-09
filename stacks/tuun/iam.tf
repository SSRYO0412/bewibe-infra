# =============================================================================
# IAM Roles and Policies
# =============================================================================
# TUUN アプリケーションで使用する IAM ロール・ポリシー
#
# 既存の Lambda 用 IAM ロールは個別に作成されているため、
# 今回は data source で参照のみ行い、import は行わない。
# 将来的に統合・整理する際に Terraform 管理下に移行する。
# =============================================================================

# -----------------------------------------------------------------------------
# 既存 IAM ロールの参照（data source）
# -----------------------------------------------------------------------------
# 各 Lambda 関数に割り当てられている既存ロールを参照

data "aws_iam_role" "create_user" {
  name = "CreateUserFunctionPython-role-qjfwg5bz"
}

data "aws_iam_role" "bulk_register" {
  name = "BulkRegisterUsersFunction-role-spl7nnrc"
}

data "aws_iam_role" "chat_api" {
  name = "chat-api-function-role-bunthz97"
}

data "aws_iam_role" "health_profile" {
  name = "HealthProfileFunction-role-3ofri2ax"
}

data "aws_iam_role" "get_gene_data" {
  name = "GetGeneDataFunction-role-euxr4mph"
}

data "aws_iam_role" "get_gene_rawdata" {
  name = "GetGeneRawdataFunction-role-2haeygqb"
}

data "aws_iam_role" "get_blood_data" {
  name = "GetBloodDataFunction-role-ssowtbg7"
}

data "aws_iam_role" "blood_analysis" {
  name = "blood-analysis-function-role-963k0ae6"
}

data "aws_iam_role" "gene_analysis_evidence" {
  name = "gene-analysis-evidence-function-role-zu9t9yyh"
}

data "aws_iam_role" "convert_gene_text" {
  name = "ConvertGeneTextToJsonFunction-role-btzpebw1"
}

data "aws_iam_role" "prepare_gene_transfer" {
  name = "PrepareGeneDataTransferFunction-role-98qt8r6h"
}

# -----------------------------------------------------------------------------
# GetGeneRawdataFunction 用 Secrets Manager アクセス権限
# -----------------------------------------------------------------------------
# Lambda が Secrets Manager から認証情報を読み取るためのポリシー

resource "aws_iam_role_policy" "get_gene_rawdata_secrets" {
  name = "SecretsManagerAccess"
  role = data.aws_iam_role.get_gene_rawdata.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.rawdata_credentials.arn
        ]
      }
    ]
  })
}
