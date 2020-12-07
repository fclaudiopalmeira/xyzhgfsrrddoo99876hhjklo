output "cloudwatch_role" {
    value = aws_iam_role.cloudwatch_role_api.arn
}

output "role" {
    value = aws_iam_role.iam_for_ecpp_lambda.arn
}

output "role_glue" {
    value = aws_iam_role.ecppDataCrawlerRole.arn
}
