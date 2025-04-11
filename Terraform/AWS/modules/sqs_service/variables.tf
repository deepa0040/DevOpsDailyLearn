
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