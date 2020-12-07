resource "aws_glue_crawler" "ecppcrl" {
  database_name   = aws_glue_catalog_database.aws_glue_catalog_database.name
  description     = "AWS Glue crawler to crawl the ecpp Data Bucket"
  name            = var.crawlername
  role            = var.role_glue
  schedule        = "cron(15 20 * * ? *)"
  schema_change_policy { 
       update_behavior = "UPDATE_IN_DATABASE"
       delete_behavior = "DELETE_FROM_DATABASE"
  }

  s3_target {
    path = "s3://${var.trans_bucket}" ## -> This is the Target ecpp-transformed-s3
  }
  configuration = <<EOF
  {
      "Version":1.0,
      "CrawlerOutput": {
          "Partitions": {
              "AddOrUpdateBehavior":"InheritFromTable"
            },
          "Tables": {
              "AddOrUpdateBehavior":"MergeNewColumns"
            }
        }
   }
EOF
}

## Crawler name = ecpp-crl



