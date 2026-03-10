# =============================================================================
# Terraform Backend Configuration
# =============================================================================
# State を S3 に保存し、DynamoDB で State Lock を管理
#
# 注意: このファイルを使用する前に、以下のリソースを手動で作成してください：
# 1. S3 バケット: tuun-terraform-state-295250016740 (既存を共有)
# 2. DynamoDB テーブル: tuun-newborn-terraform-locks (LockID をパーティションキーとする)
# =============================================================================

terraform {
  backend "s3" {
    bucket         = "tuun-terraform-state-295250016740"
    key            = "tuun_newborn/terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "tuun-newborn-terraform-locks"
  }
}
