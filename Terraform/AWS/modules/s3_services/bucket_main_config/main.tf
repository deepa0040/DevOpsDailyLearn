locals {
  s3_buckets = var.s3_buckets_config
}

resource "aws_s3_bucket" "common_bucket" {
    for_each = local.s3_buckets
    bucket = each.value.bucket_name
    tags = var.additional_tags
    lifecycle {
      prevent_destroy = false
    }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  for_each = local.s3_buckets
  bucket = aws_s3_bucket.common_bucket[each.key].id
  versioning_configuration {
    status = each.value.bucket_versioning 
  }

}


resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  for_each = {
    for k, v in local.s3_buckets : k => v if length(v.lifecycle_rules) > 0
  }

  bucket = aws_s3_bucket.common_bucket[each.key].id

  dynamic "rule" {
    for_each = each.value.lifecycle_rules

    content {
      id     = rule.value.id
      status = "Enabled"

      filter {
        prefix = rule.value.prefix
      }

      expiration {
        days = rule.value.days
      }
    }
  }
}