# Lambda Package Archive
# Similarly to Serverless Framework, we package all Lambda functions into a single ZIP file.
data "archive_file" "lambda_package_zip" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "${path.module}/lambda-packages/lambda-package.zip"
}

# Authorizer Lambda
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

# Endpoint Lambdas
resource "aws_lambda_function" "lambdas" {
  for_each = local.endpoints

  function_name = "${each.key}-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = each.value.handler_path
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

# Lambda Permissions
resource "aws_lambda_permission" "api_gateway_authorizer_permission" {
  statement_id  = "AllowAPIGatewayToInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/authorizers/*"
}

resource "aws_lambda_permission" "api_gateway_endpoint_permissions" {
  for_each = local.endpoints

  # statement_id  = "AllowAPIGatewayInvoke${replace(each.value.api_path, "/", "_")}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambdas[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/${each.value.api_method}${each.value.api_path}"
}
