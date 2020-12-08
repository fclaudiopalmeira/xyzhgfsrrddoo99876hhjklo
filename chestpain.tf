### SERVERLESS ECPP ####

### S3 Buckets for ECPP-Serverless
module "S3" {
  # Source module from local repo
  source = "../../modules/s3"
  bucket_names = var.bucket_names
  common_aws_tags = var.common_aws_tags
}

### IAM roles and policies ###
module "IAM" {
  source   = "../../modules/iam"
  region   = var.aws_region
  #bnames   = var.bucket_names
  raw_bucket       = module.S3.raw
  trans_bucket     = module.S3.trans
}

module "API_GATEWAY" {
  depends_on       = [module.S3]
  source           = "../../modules/api_gateway"
  cloudwatch_role  = module.IAM.cloudwatch_role
  raw_bucket       = module.S3.raw
  trans_bucket     = module.S3.trans
  #uri              = module.lambda.lambda_arn
}

module "lambda" {
  source               = "../../modules/lambda"
  payload              = "../../modules/lambda/ecpp_payload.zip"
  #payload              = "${module.ado_seed.bucket_domain}/ecpp_payload.zip"
  function_name        = "ecpp_lambda_test"
  rest_api_id_var      = module.API_GATEWAY.rest_api_id
  resource_id_var      = module.API_GATEWAY.resource_id
  http_method_var      = module.API_GATEWAY.http_method
  role_var             = module.IAM.role
  arn_execution        = module.API_GATEWAY.rest_api_arn
  trans_bucket         = module.S3.trans
}

module "athena" {
  depends_on       = [module.S3]
  source           = "../../modules/athena"
  query_bucket     = module.S3.query
}

module "glue" {
  depends_on       = [module.S3]
  source           = "../../modules/glue"
  trans_bucket     = module.S3.trans
  role_glue        = module.IAM.role_glue
  gluedbname       = "lambda_test"
  crawlername      = "Crawler_test"
}