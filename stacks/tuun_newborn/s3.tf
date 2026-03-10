# =============================================================================
# S3 Buckets
# =============================================================================
# TUUN Newborn アプリケーションで使用する S3 バケット
#
# バケット:
# - tuun-newborn-gene-data: 遺伝子/血液データ
# - tuun-newborn-certificates: mTLS 証明書
# - tuun-newborn-temp-transfer: データ移行用
# - tuun-newborn-config: エージェント設定 (soul.md, スキル定義, バージョン管理)
# =============================================================================

# -----------------------------------------------------------------------------
# tuun-newborn-gene-data
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "gene_data" {
  bucket = "tuun-newborn-gene-data"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gene_data" {
  bucket = aws_s3_bucket.gene_data.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "gene_data" {
  bucket = aws_s3_bucket.gene_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "gene_data" {
  bucket = aws_s3_bucket.gene_data.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 → Lambda トリガー設定
resource "aws_s3_bucket_notification" "gene_data_triggers" {
  bucket = aws_s3_bucket.gene_data.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.blood_analysis.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw-blood/"
    filter_suffix       = ".txt"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.blood_analysis.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw-blood/"
    filter_suffix       = ".csv"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.gene_analysis_evidence.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "raw-gene/"
    filter_suffix       = ".txt"
  }

  depends_on = [
    aws_lambda_permission.s3_invoke_blood_analysis,
    aws_lambda_permission.s3_invoke_gene_analysis,
  ]
}

resource "aws_lambda_permission" "s3_invoke_blood_analysis" {
  statement_id   = "S3InvokeBloodAnalysis"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.blood_analysis.function_name
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.gene_data.arn
  source_account = data.aws_caller_identity.current.account_id
}

resource "aws_lambda_permission" "s3_invoke_gene_analysis" {
  statement_id   = "S3InvokeGeneAnalysis"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.gene_analysis_evidence.function_name
  principal      = "s3.amazonaws.com"
  source_arn     = aws_s3_bucket.gene_data.arn
  source_account = data.aws_caller_identity.current.account_id
}

# -----------------------------------------------------------------------------
# tuun-newborn-certificates
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "certificates" {
  bucket = "tuun-newborn-certificates"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "certificates" {
  bucket = aws_s3_bucket.certificates.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "certificates" {
  bucket = aws_s3_bucket.certificates.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "certificates" {
  bucket = aws_s3_bucket.certificates.id
  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------------------------------------------------------
# tuun-newborn-temp-transfer
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "gene_data_transfer" {
  bucket = "tuun-newborn-temp-transfer"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "gene_data_transfer" {
  bucket = aws_s3_bucket.gene_data_transfer.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "gene_data_transfer" {
  bucket = aws_s3_bucket.gene_data_transfer.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# tuun-newborn-config (Agent Architecture v8)
# -----------------------------------------------------------------------------
# soul.md、スキル定義、バージョン manifest.json 用

resource "aws_s3_bucket" "config" {
  bucket = "tuun-newborn-config"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "config" {
  bucket = aws_s3_bucket.config.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "config" {
  bucket = aws_s3_bucket.config.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "config" {
  bucket = aws_s3_bucket.config.id
  versioning_configuration {
    status = "Enabled"
  }
}
