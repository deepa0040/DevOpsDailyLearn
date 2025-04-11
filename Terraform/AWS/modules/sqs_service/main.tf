# confirm default value we can set in sqs
resource "aws_sqs_queue" "sqs_queues" {
  for_each = var.sqs_queues

  name                      = each.value.name
  delay_seconds             = lookup(each.value, "delay_seconds", 0)
  max_message_size        = lookup(each.value, "max_message_size", 262144)
  message_retention_seconds = lookup(each.value, "message_retention_seconds", 345600)
  receive_wait_time_seconds = lookup(each.value, "receive_wait_time_seconds", 0)
  visibility_timeout_seconds = lookup(each.value, "visibility_timeout_seconds", 30)
  fifo_queue                = lookup(each.value, "fifo_queue", false)
  content_based_deduplication = each.value.fifo_queue ? lookup(each.value, "content_based_deduplication", null) : null
  kms_master_key_id         = lookup(each.value, "kms_master_key_id", "alias/aws/sqs")
  kms_data_key_reuse_period_seconds = lookup(each.value, "kms_data_key_reuse_period_seconds", 300)
  redrive_policy            = each.value.dlq_name != null ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[each.key].arn
    maxReceiveCount   = lookup(each.value, "max_receive_count", 3)
  }) : null

  tags = merge(var.common_tags, lookup(each.value, "tags", {}))
}

resource "aws_sqs_queue" "dlq" {
  for_each = {
    for key, config in var.sqs_queues : key => config if config.dlq_name != null
  }
  name                      = each.value.dlq_name
  message_retention_seconds = lookup(each.value, "dlq_retention_seconds", 1209600)
  fifo_queue                = lookup(each.value, "fifo_queue", false) # DLQ should generally match the main queue type
  tags                      = merge(var.common_tags, lookup(each.value, "dlq_tags", {}))
}

