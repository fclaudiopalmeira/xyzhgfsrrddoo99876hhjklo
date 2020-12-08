
 variable "bucket_names" {
  type = map(string)
  description = "Name of the buckets."
}

variable "common_aws_tags" {
  type = map(string)
  description = "Common AWS tags to be applied to all created resources."
}