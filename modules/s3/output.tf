output "trans" {
    value = [
    for bucket in aws_s3_bucket.ChestPain:
    bucket.id
    if bucket.id == "ecpp-transformed-s3"
  ]
}

output "raw" {
    value = [
    for bucket in aws_s3_bucket.ChestPain:
    bucket.id
    if bucket.id == "ecpp-raw-s3"
  ]
}

output "query" {
    value = [
    for bucket in aws_s3_bucket.ChestPain:
    bucket.id
    if bucket.id == "ecpp-query-s3"
  ]
}
