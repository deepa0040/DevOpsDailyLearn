output "s3_bucket_info" {
  value = {
    for k, v in aws_s3_bucket.common_bucket : k => {
      id                = v.id
      arn               = v.arn
      bucket_name       = v.bucket
      versioning_status = aws_s3_bucket_versioning.bucket_versioning[k].versioning_configuration[0].status
      lifecycle_rules = lookup(local.s3_buckets[k], "lifecycle_rules", []) # Safely get lifecycle rules
    }
  }
  description = "Map containing information about each created S3 bucket, including lifecycle rules"
}
# output "s3_bucket_info" {
#   value = {
#     for k, v in aws_s3_bucket.common_bucket : k => {
#       id              = v.id
#       arn             = v.arn
#       bucket_name     = v.bucket
#       versioning_status = aws_s3_bucket_versioning.bucket_versioning[k].versioning_configuration[0].status
#     }
#   }
#   description = "Map containing information about each created S3 bucket"
# }
# #--------------------Indvidual Print Output-----------------------------
# output "bucket_ids" {
#   value = { for k, v in aws_s3_bucket.common_bucket : k => v.id }
#   description = "Map of bucket names to their IDs"
# }

# output "bucket_arns" {
#   value = { for k, v in aws_s3_bucket.common_bucket : k => v.arn }
#   description = "Map of bucket names to their ARNs"
# }

# output "bucket_versioning_statuses" {
#   value = { for k, v in aws_s3_bucket_versioning.bucket_versioning : k => v.versioning_configuration[0].status }
#   description = "Map of bucket names to their versioning status"
# }

# output "bucket_names" {
#   value = { for k, v in aws_s3_bucket.common_bucket : k => v.bucket }
#   description = "Map of bucket names to their actual bucket names"
# }