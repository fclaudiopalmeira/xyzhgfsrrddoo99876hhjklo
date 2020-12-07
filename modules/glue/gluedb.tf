resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = var.gluedbname
  description = "Stores tables for the ecpp data"
}

## catalog_id - (Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID, and for ChestPain Pathways that is the desired Catalog ID.

## Glue Database Name = _ecpp_glu