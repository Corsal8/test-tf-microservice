locals {
  api_endpoints = {
    "/fn1" = {
      "get" = {
        lambda_arn    = aws_lambda_function.fn1_lambda.invoke_arn
        function_name = aws_lambda_function.fn1_lambda.function_name
      }
    },
    "/fn2" = {
      "get" = {
        lambda_arn    = aws_lambda_function.fn2_lambda.invoke_arn
        function_name = aws_lambda_function.fn2_lambda.function_name
      }
    },
    "/fn3" = {
      "get" = {
        lambda_arn    = aws_lambda_function.fn3_lambda.invoke_arn
        function_name = aws_lambda_function.fn3_lambda.function_name
      }
    }
  }

  openapi_paths = {
    for path, methods in local.api_endpoints : path => {
      for method, config in methods : lower(method) => {
        summary = "Integration for ${path}"
        x-amazon-apigateway-integration = {
          uri                  = config.lambda_arn
          httpMethod           = "POST"
          type                 = "aws_proxy"
          payloadFormatVersion = "2.0"
        }
        security = [{
          "authorizer" : []
        }]
      }
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "Serverless-API-${var.environment}"
  description = "Terraform microservice API"

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Serverless-API-${var.environment}"
      version = "1.0"
    }
    paths = local.openapi_paths
    components = {
      securitySchemes = {
        "authorizer" = {
          type                         = "apiKey"
          name                         = "Authorization"
          in                           = "header"
          x-amazon-apigateway-authtype = "custom"
          x-amazon-apigateway-authorizer = {
            type                         = "request"
            authorizerUri                = aws_lambda_function.authorizer_lambda.invoke_arn
            identitySource               = "context.httpMethod, context.resourcePath, method.request.header.Authorization"
            authorizerResultTtlInSeconds = 300
            authorizerCredentials        = aws_iam_role.api_gateway_authorizer_role.arn
          }
        }
      }
    }
  })
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

# Deployment and Stage
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
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
