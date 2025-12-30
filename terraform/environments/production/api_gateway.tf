locals {
  # Generate the OpenAPI paths structure directly from the config in endpoints.tf
  openapi_paths = {
    # Find all unique API paths
    for path in distinct([for e in values(local.endpoints) : e.api_path]) : path => {
      # For each unique path, build a map of its methods
      for key, endpoint in local.endpoints :
      # The key is the lowercase method (e.g., "get"), and the value is the integration object
      lower(endpoint.api_method) => {
        summary = "Integration for ${endpoint.api_path}"
        x-amazon-apigateway-integration = {
          uri                  = aws_lambda_function.lambdas[key].invoke_arn
          httpMethod           = "POST"
          type                 = "aws_proxy"
          payloadFormatVersion = "2.0"
        }
        security = [{
          "authorizer" : []
        }]
      } if endpoint.api_path == path # Only include endpoints that match the current path
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.env_config.project_name}-${var.env_config.env_name}-api"
  description = "Test Terraform Microservice API Gateway for ${var.env_config.env_name} environment"

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "${var.env_config.project_name}-${var.env_config.env_name}-api"
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
            identitySource               = "context.httpMethod, context.path, method.request.header.Authorization"
            authorizerResultTtlInSeconds = 300
            authorizerCredentials        = aws_iam_role.api_gateway_authorizer_role.arn
          }
        }
      }
    }
  })
}

# API Gateway Authorizer IAM Role
resource "aws_iam_role" "api_gateway_authorizer_role" {
  name = "${var.env_config.project_name}-${var.env_config.env_name}-api-gateway-authorizer-role"

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
  name = "${var.env_config.project_name}-${var.env_config.env_name}-api-gateway-authorizer-policy"
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
  stage_name    = var.env_config.env_name
}
