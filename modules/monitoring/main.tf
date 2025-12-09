# =============================================================================
# Monitoring Module
# =============================================================================
# CloudTrail と AWS Config を作成する再利用可能モジュール
# =============================================================================

# =============================================================================
# CloudTrail
# =============================================================================

resource "aws_s3_bucket" "cloudtrail_logs" {
  count = var.create_cloudtrail ? 1 : 0

  bucket = var.cloudtrail_s3_bucket_name

  tags = merge(var.tags, {
    Name = "CloudTrail Logs"
  })
}

resource "aws_s3_bucket_versioning" "cloudtrail_logs" {
  count = var.create_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_logs[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_logs" {
  count = var.create_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_logs[0].id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudtrail_logs" {
  count = var.create_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudtrail_logs" {
  count = var.create_cloudtrail ? 1 : 0

  bucket = aws_s3_bucket.cloudtrail_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs[0].arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs[0].arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "this" {
  count = var.create_cloudtrail ? 1 : 0

  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs[0].id
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = var.tags

  depends_on = [aws_s3_bucket_policy.cloudtrail_logs]
}

# =============================================================================
# AWS Config (Optional)
# =============================================================================

resource "aws_config_configuration_recorder" "this" {
  count = var.create_aws_config ? 1 : 0

  name     = var.config_recorder_name
  role_arn = var.config_role_arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  count = var.create_aws_config ? 1 : 0

  name       = aws_config_configuration_recorder.this[0].name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_delivery_channel" "this" {
  count = var.create_aws_config ? 1 : 0

  name           = var.config_delivery_channel_name
  s3_bucket_name = var.config_s3_bucket_name

  depends_on = [aws_config_configuration_recorder.this]
}
