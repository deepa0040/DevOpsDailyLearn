variable additional_tags {}
# variable "s3_buckets_config" {
#   type = map(object({
#     bucket_name       = string
#     bucket_versioning = string
#   }))
#   description = "Map of S3 bucket configurations (name and versioning status)"
# }

variable "s3_buckets_config" {
  type = map(object({
    bucket_name       = string
    bucket_versioning = string
    lifecycle_rules = optional(list(object({
    id      = string
    prefix  = string
    days    = number
  })))
  }))
  description = "Map of S3 bucket configurations"
}