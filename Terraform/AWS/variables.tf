variable "region" {}

#----------------------S3 Bucket---------------------------------------
#---bucket_main_config module
variable "additional_tags" {}

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
#------------------------------Cloudfront-----------------------------
variable "bucket_name" {}

#-----------------------------DynamoDb------------------------------------
variable "dynamodb_table" {
  type = map(object({
    name           = string
    billing_mode   = string
    read_capacity  = number
    write_capacity = number
    partition_key       = string
    sort_key      = string
    attributes = list(object({
      name = string
      type = string
    }))
    ttl = object({
      attribute_name = string
      enabled        = bool
    })
    dynamodb_stream_enabled   = optional(bool, false)
    dynamodb_stream_view_type = optional(string, "NEW_AND_OLD_IMAGES")
    pitr_enabled     = optional(bool, false)
    local_secondary_index = optional(list(object({
      name            = string
      sort_key        = string
      projection_type = string
      non_key_attributes = optional(list(string))
    })))
    global_secondary_index = list(object({
      name             = string
      partition_key         = string
      sort_key        = string
      write_capacity   = number
      read_capacity    = number
      projection_type  = string
      non_key_attributes = list(string)
    }))
    tags = map(string)
  }))
  description = "Configuration for the basic DynamoDB table"
}

#------------------------------------SQS module variables--------------------------


variable "sqs_queues" {
  type = map(object({
    name                      = string
    delay_seconds             = optional(number, 0)
    max_message_size        = optional(number, 262144)
    message_retention_seconds = optional(number, 345600)
    receive_wait_time_seconds = optional(number, 0)
    visibility_timeout_seconds = optional(number, 30)
    fifo_queue                = optional(bool, false)
    content_based_deduplication = optional(bool)
    kms_master_key_id         = optional(string, "alias/aws/sqs")
    kms_data_key_reuse_period_seconds = optional(number, 300)
    dlq_name                  = optional(string)
    max_receive_count       = optional(number, 3)
    dlq_retention_seconds   = optional(number, 1209600)
    tags                      = optional(map(string), {})
    dlq_tags                  = optional(map(string), {})
  }))
  default = {}
}

variable "common_tags" {
  type = map(string)
  default = {}
}

#----------------------------Cognito idp------------------------------
