resource "aws_lambda_function" "ecpp_api_lambda" {
/*   depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_log_group,
  ] */
  filename      = var.payload
  function_name = var.function_name
  role          = var.role_var
  handler       = "ecpp_api_lambda.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(var.payload)

  runtime = "python3.8"

  environment {
    variables = {
      TransformedDataBucket = "${var.trans_bucket}"
    }
  }
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.ecpp_api_lambda.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowecppAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "ecpp_api_lambda"
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  #source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/POST/event"
  source_arn = "${var.arn_execution}/*/POST/event"
}

resource "aws_api_gateway_integration" "ecpp_integration" {
  rest_api_id = var.rest_api_id_var
  resource_id = var.resource_id_var
  http_method = var.http_method_var
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ecpp_api_lambda.invoke_arn
}