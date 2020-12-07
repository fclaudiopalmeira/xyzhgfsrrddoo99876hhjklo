resource "aws_s3_bucket" "ChestPain" {
  for_each  = var.bucket_names
  bucket    = each.value
  acl       = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
  tags = var.common_aws_tags
}

resource "aws_s3_bucket_public_access_block" "ChestPain" {
  for_each  = var.bucket_names
  bucket = aws_s3_bucket.ChestPain[each.key].id ## ID
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true


}