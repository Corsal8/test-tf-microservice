data "archive_file" "lambda_package_zip" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "${path.module}/lambda-packages/lambda-package.zip"
}

resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "authorizer-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = "lambdas/authorizer/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}
resource "aws_lambda_function" "fn1_lambda" {
  function_name = "fn1-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = "lambdas/fn1/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_lambda_function" "fn2_lambda" {
  function_name = "fn2-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = "lambdas/fn2/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_lambda_function" "fn3_lambda" {
  function_name = "fn3-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = "lambdas/fn3/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}
