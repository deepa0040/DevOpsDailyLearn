module "aws_s3_bucket" {
  source            = "./modules/s3_services/bucket_main_config"
  s3_buckets_config = var.s3_buckets_config
  additional_tags   = var.additional_tags
}
module "cloudfront" {
  source = "./modules/cloudfront_service"
  depends_on = [module.aws_s3_bucket]
  additional_tags   = var.additional_tags
  region = var.region
  bucket_name = var.bucket_name
  bucket_arn = module.aws_s3_bucket.s3_bucket_info["archive-bucket"].arn
}

module "dynamodb_table" {
  source = "./modules/dynamodb"
  dynamodb_table = var.dynamodb_table
} 

module "sqs_service" {
  source = "./modules/sqs_service"
  common_tags = var.common_tags
  sqs_queues = var.sqs_queues

}
module "cognito" {
  source ="./modules/cognito_service"
  de
}