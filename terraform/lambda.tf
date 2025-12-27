resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "authorizer-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = var.lambda_artifacts_bucket_name
  s3_key            = var.authorizer_lambda_artifact_s3_key
  source_code_hash  = var.authorizer_lambda_artifact_hash

  handler = "index.handler"
  runtime = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_lambda_function" "server_lambda" {
  function_name = "server-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = var.lambda_artifacts_bucket_name
  s3_key            = var.server_lambda_artifact_s3_key
  source_code_hash  = var.server_lambda_artifact_hash

  handler = "index.handler"
  runtime = "nodejs20.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}
