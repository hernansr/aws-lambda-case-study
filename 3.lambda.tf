resource "aws_iam_role" "role" {
  name               = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name   = "policy"
    policy = data.aws_iam_policy_document.policy_doc.json
  }
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    actions = [
       "cloudwatch:PutMetricAlarm",
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/lambda/lambda_function.zip"
  function_name = "lambda"
  role          = aws_iam_role.role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  environment {
    variables = {
      ACCOUNT = var.account
      REGION  = var.region
    }
  }
}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}