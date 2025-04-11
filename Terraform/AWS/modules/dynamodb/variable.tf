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


