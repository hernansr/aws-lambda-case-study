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
