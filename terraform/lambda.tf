data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "visitor_counter_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions   = ["dynamodb:UpdateItem",
                    "dynamodb:GetItem"]
    resources = [aws_dynamodb_table.visit_counter.arn]
  }
  statement {
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.visitor_alerts.arn]
  }
  statement {
    actions   = ["logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "lambda_policy_attach" {
    role = aws_iam_role.lambda_exec_role.name
    policy = data.aws_iam_policy_document.lambda_permissions.json
} 

resource "aws_iam_policy" "visitor_counter_policy" {
    name   = "visitor_counter_policy"
    policy = data.aws_iam_policy_document.lambda_permissions.json
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file  = "${path.module}/api/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "visitor_counter" {
filename         = data.archive_file.lambda_zip.output_path
    function_name    = "UpdateVisitorCounter"
    role             = aws_iam_role.lambda_exec_role.arn
    handler          = "lambda_function.lambda_handler"
    runtime          = "python3.10"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256

    environment {
        variables = {
            TABLE_NAME = aws_dynamodb_table.visit_counter.name
            TOPIC_ARN  = aws_sns_topic.visitor_alerts.arn
            MY_IP      = var.my_ip
        }
    }
}

resource "aws_lambda_function_url" "visitor_counter_url" {
  function_name = aws_lambda_function.visitor_counter.function_name
    authorization_type = "NONE"

    cors{
        allow_credentials = false
        allow_origins     = ["https://hubert-dziedzic.pl", "https://www.hubert-dziedzic.pl", "http://localhost:3000"]
        allow_methods = ["GET", "POST"]
        allow_headers = ["*"]
        max_age = 86400
    }
}