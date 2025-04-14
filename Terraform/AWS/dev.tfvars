region = "us-west-2"
additional_tags = {
  "ohi:project"     = "common",
  "ohi:application" = "common",
  "ohi:module"      = "common-be",
  "ohi:environment" = "usdev-usw2"
}

s3_buckets_config = {

  "data-lake" = {
    bucket_name       = "qmy-data-lake-2025-sukteri" # Ensure globally unique, including location context
    bucket_versioning = "Enabled"
    lifecycle_rules = [
      { id = "delete-mobile-automated-ut-reports", prefix = "operations/automated-ut-reports/mobile/", days = 90 },
      { id = "delete-eslint-reports", prefix = "operations/static-code-report/", days = 180 }
    ]
  }

  "processing-bucket" = {
    bucket_name       = "qprocessing-area-april-2025-sukteri" # Ensure globally unique
    bucket_versioning = "Enabled"
    lifecycle_rules = [
      { id = "delete-mobile-automated-ut-reports", prefix = "operations/automated-ut-reports/mobile/", days = 90 },
      { id = "delete-eslint-reports", prefix = "operations/static-code-report/", days = 180 }
    ]
  }

  "archive-bucket" = {
    bucket_name       = "qlong-term-archive-2025-sukteri" # Ensure globally unique
    bucket_versioning = "Disabled"
    lifecycle_rules = []
  }

  "logs-bucket" = {
    bucket_name       = "qapplication-logs-april-2025-sukteri" # Ensure globally unique
    bucket_versioning = "Suspended" 
    lifecycle_rules = [
      { id = "delete-mobile-automated-ut-reports", prefix = "operations/automated-ut-reports/mobile/", days = 90 },
      { id = "delete-eslint-reports", prefix = "operations/static-code-report/", days = 180 }
    ]                          
  }
}

#------------------------------------Cloudfront Variable--------------------------
bucket_name       = "qlong-term-archive-2025-sukteri"


#-------------------------------------Dynamodb--------------------------------

dynamodb_table = {
  "table1" = {
  name           = "NewGameScoresTable"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  partition_key       = "UserId"
  sort_key      = "GameTitle"
  attributes = [
     { name = "UserId", type = "S" },
     { name = "GameTitle", type = "S" },
     { name = "TopScore", type = "N" }
  ]
  ttl = {
    attribute_name = "TimeToExist"
    enabled        = false
  }
  local_secondary_index = [
      { name = "OrderByStatus", sort_key = "GameTitle", projection_type = "ALL" },
      { name = "OrderByOrder", sort_key = "GameTitle", projection_type = "INCLUDE", non_key_attributes = ["Timestamp"] } # Assuming Timestamp exists
    ]
  global_secondary_index = [
    {
      name             = "GameTitleIndex"
      partition_key          = "GameTitle"
      sort_key        = "TopScore"
      write_capacity   = 10
      read_capacity    = 10
      projection_type  = "INCLUDE"
      non_key_attributes = ["UserId"]
    },
  ]
  tags = { Name = "another-data-table", Environment = "production" }

  dynamodb_stream_enabled   = true
    dynamodb_stream_view_type = "NEW_IMAGE"
    pitr_enabled     = true
},
 "table2" = {
  name           = "NewGameScoresTable3"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  partition_key       = "UserId"
  sort_key      = "GameTitle"
  attributes = [
     { name = "UserId", type = "S" },
     { name = "GameTitle", type = "S" },
     { name = "TopScore", type = "N" }
  ]
  ttl = {
    attribute_name = "TimeToExist"
    enabled        = false
  }
  local_secondary_index = [
      # { name = "OrderByStatus", sort_key = "GameTitle", projection_type = "ALL" },
      # { name = "OrderByOrder", sort_key = "GameTitle", projection_type = "INCLUDE", non_key_attributes = ["Timestamp"] } # Assuming Timestamp exists
    ]
  global_secondary_index = [
    {
      name             = "GameTitleIndex"
      partition_key          = "GameTitle"
      sort_key        = "TopScore"
      write_capacity   = 10
      read_capacity    = 10
      projection_type  = "INCLUDE"
      non_key_attributes = ["UserId"]
    },
  ]
  tags = { Name = "another-data-table", Environment = "production" }
  
  dynamodb_stream_enabled   = true
    dynamodb_stream_view_type = "NEW_IMAGE"
    pitr_enabled     = true
}
}

#---------------------------------------SQS module variables--------------------------------
sqs_queues = {
  "primary-queue" = {
    name                      = "primary-app-queue"
    delay_seconds             = 5
    visibility_timeout_seconds = 45
    tags = {
      Environment = "staging"
      Team        = "core"
    }
  }

  "worker-queue" = {
    name                      = "background-worker-queue"
    receive_wait_time_seconds = 10
    dlq_name                  = "background-worker-dlq"
    max_receive_count       = 3
    dlq_retention_seconds   = 604800 # 7 days
    tags = {
      Environment = "production"
      Priority    = "medium"
    }
    dlq_tags = {
      Environment = "production"
      Type        = "dead-letter"
    }
  }

  "order-events-fifo" = {
    name                      = "order-events.fifo"
    fifo_queue                = true
    content_based_deduplication = true
    dlq_name                  = "order-events-dlq.fifo"
    message_retention_seconds = 86400 # 1 day
    tags = {
      Module = "orders"
      Type   = "event"
    }
    dlq_tags = {
      Module = "orders"
      Type   = "dead-letter"
    }
  }

  "logging-queue" = {
    name                      = "application-logs"
    message_retention_seconds = 259200 # 3 days
    tags = {
      Service = "logging"
      Tier    = "secondary"
    }
  }
}

common_tags = {
  ManagedBy = "Terraform"
  Region    = "ap-south-1" # Assuming your region is ap-south-1
  Project   = "my-application"
}

#----------------------------------------Cognito--------------------------------

