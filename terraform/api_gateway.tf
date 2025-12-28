resource "aws_api_gateway_rest_api" "api" {
  name        = "Serverless-API-${var.environment}"
  description = "Terraform microservice API"
}

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                             = "lambda_authorizer-${var.environment}"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  authorizer_uri                   = aws_lambda_function.authorizer_lambda.invoke_arn
  authorizer_credentials           = aws_iam_role.api_gateway_authorizer_role.arn
  type                             = "REQUEST"
  identity_source                  = "context.httpMethod, context.resourcePath, method.request.header.Authorization"
  authorizer_result_ttl_in_seconds = 300
}

resource "aws_iam_role" "api_gateway_authorizer_role" {
  name = "api_gateway_authorizer_role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_authorizer_policy" {
  name = "api_gateway_authorizer_policy-${var.environment}"
  role = aws_iam_role.api_gateway_authorizer_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.authorizer_lambda.arn
      }
    ]
  })
}

resource "aws_lambda_permission" "api_gateway_authorizer_permission" {
  statement_id  = "AllowAPIGatewayToInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/authorizers/${aws_api_gateway_authorizer.lambda_authorizer.id}"
}

# Resources for the /fn1 endpoint
resource "aws_api_gateway_resource" "fn1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "fn1"
}

resource "aws_api_gateway_method" "fn1_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.fn1.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "fn1_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.fn1.id
  http_method             = aws_api_gateway_method.fn1_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fn1_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_fn1_permission" {
  statement_id  = "AllowAPIGatewayToInvokeFn1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn1_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Resources for the /fn2 endpoint
resource "aws_api_gateway_resource" "fn2" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "fn2"
}

resource "aws_api_gateway_method" "fn2_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.fn2.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "fn2_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.fn2.id
  http_method             = aws_api_gateway_method.fn2_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fn2_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_fn2_permission" {
  statement_id  = "AllowAPIGatewayToInvokeFn2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn2_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Resources for the /fn3 endpoint
resource "aws_api_gateway_resource" "fn3" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "fn3"
}

resource "aws_api_gateway_method" "fn3_get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.fn3.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "fn3_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.fn3.id
  http_method             = aws_api_gateway_method.fn3_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.fn3_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_fn3_permission" {
  statement_id  = "AllowAPIGatewayToInvokeFn3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn3_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Deployment and Stage
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = filemd5("${path.module}/api_gateway.tf")
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.environment
}
