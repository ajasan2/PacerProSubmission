provider "aws" {
    region = "us-east-2"
}

resource "aws_sns_topic" "alerts" {
    name = "latency-alerts"
}

resource "aws_instance" "app_server" {
    ami = "ami-0b0b78dcacbab728f"
    instance_type = "t2.micro"
}

resource "aws_iam_role" "lambda_role" {
    name = "lambda_reboot_sns_role"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_least_privilege_policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "ec2:RebootInstances",
        Effect   = "Allow",
        Resource = aws_instance.app_server.arn
      },
      {
        Action = "sns:Publish",
        Effect = "Allow",
        Resource = aws_sns_topic.alerts.arn
      },
      {
        Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda_function/main.py"
  output_path = "lambda_function.zip"
}

# Lambda function
resource "aws_lambda_function" "remediator" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "latency_remediator"
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
        INSTANCE_ID     = aws_instance.app_server.id
        SNS_TOPIC_ARN   = aws_sns_topic.alerts.arn
    }
  }
}

resource "aws_lambda_function_url" "webhook" {
    function_name       = aws_lambda_function.remediator.function_name
    authorization_type  = "NONE"
}

output "lambda_url" {
    value = aws_lambda_function_url.webhook.function_url
}