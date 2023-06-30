data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda" {
  type = "zip"
  source_file = "${path.module}/assets/function/handler.py"
  output_path = "${path.module}/assets/function/lambda_function_payload.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = "yt-website-lambda"
  runtime = "python3.9"
  handler = "handler.lambda_handler"
  filename = "${path.module}/assets/function/lambda_function_payload.zip"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  role = aws_iam_role.iam_for_lambda.arn
}

resource "aws_apigatewayv2_api" "lambda_gw" {
  name = "yt-website-api"
  protocol_type = "HTTP"
  # Connected to function here!
  target = aws_lambda_function.lambda.arn
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-cors.html
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["content-type"]
  }
}
