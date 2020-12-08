 variable "region" {
 type = string
 description = "AWS Region used for deployment of all non-global resources."
}
/* 
variable "bnames" {
 type = string
 description = "Bucket names for the IAM roles"
}
 */
variable "raw_bucket" {
 type = string
 description = "Bucket names for the IAM roles"
}

variable "trans_bucket" {
 type = string
 description = "Bucket names for the IAM roles"
}
/* 
variable "srvless_s3datalake" {
  description = "Policy values for S3  as a target"
}

variable "srvless_dynamodb" {
  description = "Policy values for DynamoDB as a target"
}

variable "srvless_jdbc" {
  description = "Policy values for JDBC as a target"
}

variable "srvless_gluecatalog" {
  description = "Policy values for Glue Catalog as a target"
} */