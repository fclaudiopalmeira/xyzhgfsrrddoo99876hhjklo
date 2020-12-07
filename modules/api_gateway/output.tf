  output "rest_api_id" {
  value = aws_api_gateway_rest_api.ecpp_rest_api.id
  }
  
  output "resource_id" {
  value = aws_api_gateway_resource.ecpp_resource.id
  }
  output "http_method" {
  value = aws_api_gateway_method.ecpp_method.http_method
  }

  output "rest_api_arn" {
  value = aws_api_gateway_rest_api.ecpp_rest_api.arn
  }