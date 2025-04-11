#---Resource creation: doneuntuuntu
#---TTL : enable disable done
#---local secondar index: done
#---global secondaru index: done
#---DB stream enable disable: done
#--- PITR: done
#pending
#- trigger, kinesis stream

locals {
  dynamodb_table = var.dynamodb_table
}


resource "aws_dynamodb_table" "basic_dynamodb_table" {
  for_each = local.dynamodb_table
  name           = each.value.name
  billing_mode   = each.value.billing_mode
  hash_key       = each.value.partition_key
  range_key      = each.value.sort_key

  dynamic "attribute" {
    for_each = each.value.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  ttl {
    attribute_name = each.value.ttl.attribute_name
    enabled        = each.value.ttl.enabled
  }

  dynamic "local_secondary_index" {
    for_each = each.value.local_secondary_index
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.sort_key
      projection_type = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", [])
    }
  }

  dynamic "global_secondary_index" {
    for_each = each.value.global_secondary_index
    content {
      name             = global_secondary_index.value.name
      hash_key         = global_secondary_index.value.partition_key
      range_key        = global_secondary_index.value.sort_key
      projection_type  = global_secondary_index.value.projection_type
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", [])
      # read_capacity and write_capacity for GSI are only relevant for PROVISIONED mode
      write_capacity   = each.value.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "write_capacity", null) : null
      read_capacity    = each.value.billing_mode == "PROVISIONED" ? lookup(global_secondary_index.value, "read_capacity", null) : null
    }
  }

  tags = each.value.tags

  stream_enabled   = each.value.dynamodb_stream_enabled
  stream_view_type = each.value.dynamodb_stream_enabled ? each.value.dynamodb_stream_view_type : null

  point_in_time_recovery {
    enabled = each.value.pitr_enabled
  }

  # Only include read_capacity and write_capacity if billing_mode is PROVISIONED
  read_capacity  = each.value.billing_mode == "PROVISIONED" ? each.value.read_capacity : null
  write_capacity = each.value.billing_mode == "PROVISIONED" ? each.value.write_capacity : null
}