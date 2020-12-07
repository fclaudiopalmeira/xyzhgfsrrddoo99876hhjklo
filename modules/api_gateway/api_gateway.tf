resource "aws_api_gateway_account" "ecpp_account" {
  cloudwatch_role_arn = var.cloudwatch_role
}
### NEED TO CREATE AN OUTPUT FOR THE API KEY
resource "aws_api_gateway_api_key" "ecpp_ApiKey" {
  depends_on = [aws_api_gateway_deployment.ecpp_api_deployment, aws_api_gateway_stage.ecpp_stage, aws_api_gateway_usage_plan.ecpp_UsagePlan]
  name = "ecpp_api_key"
  description = "CloudFormation API Key for ecpp"
  enabled = "true"
}

resource "aws_api_gateway_usage_plan" "ecpp_UsagePlan" {
  depends_on = [aws_api_gateway_deployment.ecpp_api_deployment, aws_api_gateway_stage.ecpp_stage]
  name         = "ecpp_usage_plan"
  description  = "ecpp Usage Plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.ecpp_rest_api.id
    stage  = aws_api_gateway_stage.ecpp_stage.stage_name
  }

  api_stages {
    api_id = aws_api_gateway_rest_api.ecpp_rest_api.id
    stage  = aws_api_gateway_deployment.ecpp_api_deployment.stage_name
  }
/* 
  quota_settings {
    limit  = 20
    offset = 2
    period = "WEEK"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  } */
}


resource "aws_api_gateway_usage_plan_key" "ecpp_usage_plan_key" {
  key_id        = aws_api_gateway_api_key.ecpp_ApiKey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.ecpp_UsagePlan.id
}

resource "aws_api_gateway_rest_api" "ecpp_rest_api" {
  name        = "EcppAPI"
  description = "API for ecpp"
  api_key_source = "HEADER"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

}

#### NEEDS SOME MORE WORK
resource "aws_api_gateway_stage" "ecpp_stage" {
   # depends_on  = [aws_api_gateway_account.ecpp_account]
  stage_name    = "Prod"
  rest_api_id   = aws_api_gateway_rest_api.ecpp_rest_api.id
  deployment_id = aws_api_gateway_deployment.ecpp_api_deployment.id
    variables = {
    raw_bucket = "${var.raw_bucket}"
    trans_bucket = "${var.trans_bucket}"
  }
}




resource "aws_api_gateway_deployment" "ecpp_api_deployment" {
  # depends_on  = [aws_api_gateway_integration.ecpp_integration, aws_api_gateway_method.ecpp_method, aws_api_gateway_method_settings.ecpp_method_settings]
  rest_api_id = aws_api_gateway_rest_api.ecpp_rest_api.id
  stage_name  = "DummyStage"
}

resource "aws_api_gateway_resource" "ecpp_resource" {
  rest_api_id = aws_api_gateway_rest_api.ecpp_rest_api.id
  parent_id   = aws_api_gateway_rest_api.ecpp_rest_api.root_resource_id
  path_part   = "/*"
}

resource "aws_api_gateway_method" "ecpp_method" {
  #depends_on = [lambdaApiGatewayInvoke]  ## move the lambda invoke here
  rest_api_id   = aws_api_gateway_rest_api.ecpp_rest_api.id
  resource_id   = aws_api_gateway_resource.ecpp_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method_settings" "ecpp_method_settings" {
  rest_api_id = aws_api_gateway_rest_api.ecpp_rest_api.id
  stage_name  = aws_api_gateway_stage.ecpp_stage.stage_name
  method_path = "${aws_api_gateway_resource.ecpp_resource.path_part}/${aws_api_gateway_method.ecpp_method.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    data_trace_enabled = true

  }
}
