#### IAM PROGRAMATIC USERS,POLICIES AND GROUP #####

resource "aws_iam_group" "wrds_programatic" {
  name = "wrds-programatic-${var.region}"
  path = "/users/"
}

resource "aws_iam_group_policy" "AthenaAccess_Pol" {
  name  = "AthenaAccess-Pol"
  group = aws_iam_group.wrds_programatic.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "Athena:GetCatalogs",
        "Athena:QueryResults",
        "Athena:Table",
        "Athena:Tables",
        "Athena:RunQuery",
        "Athena:StartQueryExecution",
        "Athena:StopQueryExecution",
        "Athena:GetQueryResults",
        "Athena:GetQueryResultsStream",
        "Athena:GetQueryExecution",
        "Athena:GetWorkgroup"
      ],
      "Resource": [
        "arn:aws:athena:ap-southeast-2:344185353287:workgroup/wrds-programatic-${var.region}"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}




#### IAM ROLE FOR THE LAMBDA FUNCTION ####
resource "aws_iam_role" "iam_for_ecpp_lambda" {
  name = "iam_for_ecpp_lambda"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# MANAGED POLICY FOR THE LAMBDA FUNCTION LOGGING. See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

### IAM POLICY ATTACHMENTS

## Attachment for the Logging
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_ecpp_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

### IAM POLICY FOR ATHENA
resource "aws_iam_policy" "AthenaAccess_Pol" {
  name        = "AthenaAccess_Pol"
  path        = "/"
  description = "IAM policy for Athena Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "Athena:GetCatalogs",
                "Athena:QueryResults",
                "Athena:Table",
                "Athena:Tables",
                "Athena:RunQuery",
                "Athena:StartQueryExecution",
                "Athena:StopQueryExecution",
                "Athena:GetQueryResults",
                "Athena:GetQueryResultsStream",
                "Athena:GetQueryExecution",
                "Athena:GetWorkgroup"
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


## Attachment for the Athena access 
resource "aws_iam_role_policy_attachment" "athena_access" {
  role       = aws_iam_role.iam_for_ecpp_lambda.name
  policy_arn = aws_iam_policy.AthenaAccess_Pol.arn
}

### IAM BUCKET ACCESS POLICY
resource "aws_iam_policy" "bucket_access" {
  name        = "bucket_access"
  path        = "/"
  description = "IAM policy for S3 Bucket Access"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.trans_bucket}*",
                "arn:aws:s3:::${var.raw_bucket}*",
                "arn:aws:s3:::${var.trans_bucket}",
                "arn:aws:s3:::${var.raw_bucket}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
}

## Attachment for the Bucket access 
resource "aws_iam_role_policy_attachment" "bucket_access" {
  role       = aws_iam_role.iam_for_ecpp_lambda.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

### IAM GLUE TABLE ACCESS POLICY
resource "aws_iam_policy" "GlueTableAccess_Pol" {
  name        = "GlueTableAccess_Pol"
  path        = "/"
  description = "IAM policy for Glue Table Access"

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

## Attachment for the Glue Table access 
resource "aws_iam_role_policy_attachment" "GlueTableAccess" {
  role       = aws_iam_role.iam_for_ecpp_lambda.name
  policy_arn = aws_iam_policy.GlueTableAccess_Pol.arn
}

### IAM QUERY BUCKET ACCESS POLICY
resource "aws_iam_policy" "QueryBucketAccess_Pol" {
  name        = "QueryBucketAccess_Pol"
  path        = "/"
  description = "IAM policy for the Query S3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:*"
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

## Attachment for the Query Bucket access 
resource "aws_iam_role_policy_attachment" "QueryBucketAccess_Pol" {
  role       = aws_iam_role.iam_for_ecpp_lambda.name
  policy_arn = aws_iam_policy.QueryBucketAccess_Pol.arn
}



### CLOUDWATCH ROLE FOR THE API GATEWAY #####


### THE ROLE AND ROLE POLICY MUST BE USED ON THE API ACCOUNT, -> cloudwatch_role_arn = var.cloudwatch_role
resource "aws_iam_role" "cloudwatch_role_api" {
  name = "api_gateway_cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_role_api" {
  name = "default"
  role = aws_iam_role.cloudwatch_role_api.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


### GLUE ROLE AND POLICY
resource "aws_iam_role" "ecppDataCrawlerRole" {
  name = "ecppDataCrawlerRole"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.trans_bucket}*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
/* 
  tags = {
    Name         = var.bucket
    Environment  = "Dev"
    Purpose      = "ecpp Lake Bucket"
    Role         = "Storing ecpp data files"
    Organisation = var.Organisation
    Environment = var.Environment
    Tier = var.Tier
    Appname = var.Appname
    Description = var.Description
    Module = var.Module
    BillingIdentifier = var.BillingIdentifier
    MaintenanceWindow = var.MaintenanceWindow
    ExpirationDate = var.ExpirationDate
    ProductOwner = var.ProductOwner
    Project = var.Project
  } */
}

### Policy for AWS Glue service role which allows access to related services including EC2, S3, and Cloudwatch Logs
resource "aws_iam_role_policy_attachment" "Glue_default_Policy" {
  role        = aws_iam_role.ecppDataCrawlerRole.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}