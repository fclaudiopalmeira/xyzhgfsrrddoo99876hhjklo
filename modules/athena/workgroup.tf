resource "aws_athena_workgroup" "Athena_ecpp_workgroup" {
  name = "Athena-ecpp-workgroup"
  state = "ENABLED" ## <- It will always default to enabled, this setting is here for information purposes only
  description = "ECPP Athena WorkGroup"
  force_destroy = "true"
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
    result_configuration {
      output_location = "s3://${var.query_bucket}"
    }
  }
}

