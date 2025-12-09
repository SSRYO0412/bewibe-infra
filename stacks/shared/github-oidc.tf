# =============================================================================
# GitHub Actions OIDC Authentication
# =============================================================================
# GitHub ActionsからAWSにセキュアにアクセスするための設定
#
# 構成:
# - GitHub OIDC Provider
# - terraform-ci-role（IAMロール）
# =============================================================================

# -----------------------------------------------------------------------------
# GitHub OIDC Provider
# -----------------------------------------------------------------------------

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# -----------------------------------------------------------------------------
# CI用IAMロール
# -----------------------------------------------------------------------------

resource "aws_iam_role" "terraform_ci" {
  name = "terraform-ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:SSRYO0412/bewibe-infra:*"
        }
      }
    }]
  })
}

# -----------------------------------------------------------------------------
# IAMポリシーアタッチメント
# -----------------------------------------------------------------------------
# 注意: AdministratorAccessは本番では最小権限に絞ることを推奨

resource "aws_iam_role_policy_attachment" "terraform_ci" {
  role       = aws_iam_role.terraform_ci.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
