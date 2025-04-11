output "s3_buckets_detailed_info" {
  value = module.aws_s3_bucket.s3_bucket_info
  description = "Detailed information about each created S3 bucket from the child module"
}
#------------------------------Output in individual block-----------------------
# output "all_bucket_ids" {
#   value       = module.aws_s3_bucket.bucket_ids
#   description = "List of all created S3 bucket IDs"
# }

# output "all_bucket_arns" {
#   value       = module.aws_s3_bucket.bucket_arns
#   description = "List of all created S3 bucket ARNs"
# }

# output "all_bucket_versioning_statuses" {
#   value       = module.aws_s3_bucket.bucket_versioning_statuses
#   description = "List of all created S3 bucket versioning statuses"
# }

# output "all_bucket_names" {
#   value       = module.aws_s3_bucket.bucket_names
#   description = "List of all created S3 bucket names"
# }