locals {
  authorizer_lambda_name = "${var.env_config.project_name}-${var.env_config.env_name}-authorizer-lambda"
  endpoint_lambda_names = {
    for k, v in local.endpoints : k => "${var.env_config.project_name}-${var.env_config.env_name}-${k}-lambda"
  }

  env_variables = {
    PROJECT_NAME        = var.env_config.project_name,
    ENVIRONMENT         = var.env_config.env_name,
    DYNAMODB_TABLE_NAME = var.dynamodb_config.table_name,
    DB_USER             = var.sql_server_config.db_user,
    DB_PASSWORD         = var.sql_server_config.db_password,
    DB_NAME             = var.sql_server_config.db_name,
    HOST                = var.sql_server_config.db_host,
  }
}

# Lambda Package Archive
# Similarly to Serverless Framework, we package all Lambda functions into a single ZIP file.
data "archive_file" "lambda_package_zip" {
  type        = "zip"
  source_dir  = "../../../dist"
  output_path = "${path.module}/lambda-packages/lambda-package.zip"
}

# Authorizer Lambda
resource "aws_lambda_function" "authorizer_lambda" {
  function_name = local.authorizer_lambda_name
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = var.lambda_config.timeout_seconds

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = "lambdas/authorizer/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = local.env_variables
  }

  vpc_config {
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }
}

resource "aws_cloudwatch_log_group" "authorizer_lambda_log_group" {
  name              = "/aws/lambda/${local.authorizer_lambda_name}"
  retention_in_days = var.lambda_config.log_retention_days
}

# Endpoint Lambdas
resource "aws_lambda_function" "lambdas" {
  for_each = local.endpoints

  function_name = local.endpoint_lambda_names[each.key]
  role          = aws_iam_role.lambda_exec_role.arn
  timeout       = var.lambda_config.timeout_seconds

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.lambda_package_zip.key
  s3_object_version = aws_s3_object.lambda_package_zip.version_id

  handler = each.value.handler_path
  runtime = "nodejs22.x"

  environment {
    variables = local.env_variables
  }

  vpc_config {
    subnet_ids         = var.vpc_config.subnet_ids
    security_group_ids = var.vpc_config.security_group_ids
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_groups" {
  for_each = local.endpoints

  name              = "/aws/lambda/${local.endpoint_lambda_names[each.key]}"
  retention_in_days = var.lambda_config.log_retention_days
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
