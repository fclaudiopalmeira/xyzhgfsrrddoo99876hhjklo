#### OBJECT ACCESS POLICIES

resource "aws_iam_group_policy" "DataObj" {
  name  = "DataObjAccess-pol"
  group = aws_iam_group.wrds_programatic.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::${var.trans_bucket}*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "Gluetable" {
  name  = "GlueTableAccess-pol"
  group = aws_iam_group.wrds_programatic.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "glue:GetTable*",
        "glue:GetTables",
        "glue:GetDatabase*",
        "glue:GetDatabases",
        "glue:GetPartition*"
      ],
      "Resource": [
        "arn:aws:glue:ap-southeast-2:344185353287:catalog",
        "arn:aws:glue:ap-southeast-2:344185353287:database/c-ae-d_ecpp_glu",
        "arn:aws:glue:ap-southeast-2:344185353287:table/c-ae-d_ecpp_glu/*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "QueryBucket" {
  name  = "QueryBucketAccess-pol"
  group = aws_iam_group.wrds_programatic.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::c-ae-d-ecpp-query-s3",
        "arn:aws:s3:::c-ae-d-ecpp-query-s3*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy" "s3Console" {
  name  = "s3ConsoleAccess-pol"
  group = aws_iam_group.wrds_programatic.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}




