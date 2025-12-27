resource "aws_api_gateway_rest_api" "api" {
  name        = "Serverless-API-${var.environment}"
  description = "Terraform microservice API"
}

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  name                   = "lambda_authorizer-${var.environment}"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  authorizer_uri         = aws_lambda_function.authorizer_lambda.invoke_arn
  authorizer_credentials = aws_iam_role.api_gateway_authorizer_role.arn
  type                   = "TOKEN"
  identity_source        = "method.request.header.Authorization"
}

resource "aws_iam_role" "api_gateway_authorizer_role" {
  name = "api_gateway_authorizer_role-${var.environment}"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
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
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "lambda:InvokeFunction"
        Effect    = "Allow"
        Resource  = aws_lambda_function.authorizer_lambda.arn
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

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = ""
}

resource "aws_api_gateway_method" "any" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.any.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.server_lambda.invoke_arn
}

resource "aws_lambda_permission" "api_gateway_server_permission" {
  statement_id  = "AllowAPIGatewayToInvokeServer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.server_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.root.id,
      aws_api_gateway_method.any.id,
      aws_api_gateway_integration.lambda.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.environment
}
