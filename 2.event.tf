resource "aws_cloudwatch_event_rule" "rule" {
  name = "rule"

  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["pending"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.rule.name
  arn       = aws_lambda_function.lambda.arn

  depends_on = [aws_lambda_function.lambda]
}