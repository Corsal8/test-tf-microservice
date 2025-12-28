data "archive_file" "authorizer_lambda_zip" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "${path.module}/lambda-packages/authorizer-lambda.zip"
}

resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "authorizer-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = data.archive_file.authorizer_lambda_zip.output_path
  source_code_hash = data.archive_file.authorizer_lambda_zip.output_base64sha256

  handler = "lambdas/authorizer/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

data "archive_file" "server_lambda_zip" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "${path.module}/lambda-packages/server-lambda.zip"
}

resource "aws_lambda_function" "server_lambda" {
  function_name = "server-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = data.archive_file.server_lambda_zip.output_path
  source_code_hash = data.archive_file.server_lambda_zip.output_base64sha256

  handler = "lambdas/server/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}
