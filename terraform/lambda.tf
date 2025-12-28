data "archive_file" "authorizer_lambda_zip" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "${path.module}/lambda-packages/authorizer-lambda.zip"
}

resource "aws_lambda_function" "authorizer_lambda" {
  function_name = "authorizer-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.authorizer_lambda_zip.key
  s3_object_version = aws_s3_object.authorizer_lambda_zip.version_id

  handler = "lambdas/authorizer/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

# data "archive_file" "server_lambda_zip" {
#   type        = "zip"
#   source_dir  = "../dist"
#   output_path = "${path.module}/lambda-packages/server-lambda.zip"
# }

# resource "aws_lambda_function" "server_lambda" {
#   function_name = "server-lambda-${var.environment}"
#   role          = aws_iam_role.lambda_exec_role.arn

#   s3_bucket         = aws_s3_bucket.lambda_bucket.id
#   s3_key            = aws_s3_object.server_lambda_zip.key
#   s3_object_version = aws_s3_object.server_lambda_zip.version_id

#   handler = "lambdas/server/index.handler"
#   runtime = "nodejs22.x"

#   environment {
#     variables = {
#       ENVIRONMENT = var.environment
#     }
#   }
# }

# data "archive_file" "fn1_lambda_zip" {
#   type        = "zip"
#   source_dir  = "../dist"
#   output_path = "${path.module}/lambda-packages/fn1-lambda.zip"
# }

# resource "aws_lambda_function" "fn1_lambda" {
#   function_name = "fn1-lambda-${var.environment}"
#   role          = aws_iam_role.lambda_exec_role.arn

#   s3_bucket         = aws_s3_bucket.lambda_bucket.id
#   s3_key            = aws_s3_object.fn1_lambda_zip.key
#   s3_object_version = aws_s3_object.fn1_lambda_zip.version_id

#   handler = "lambdas/fn1/index.handler"
#   runtime = "nodejs22.x"

#   environment {
#     variables = {
#       ENVIRONMENT = var.environment
#     }
#   }
# }

# data "archive_file" "fn2_lambda_zip" {
#   type        = "zip"
#   source_dir  = "../dist"
#   output_path = "${path.module}/lambda-packages/fn2-lambda.zip"
# }

# resource "aws_lambda_function" "fn2_lambda" {
#   function_name = "fn2-lambda-${var.environment}"
#   role          = aws_iam_role.lambda_exec_role.arn

#   s3_bucket         = aws_s3_bucket.lambda_bucket.id
#   s3_key            = aws_s3_object.fn2_lambda_zip.key
#   s3_object_version = aws_s3_object.fn2_lambda_zip.version_id

#   handler = "lambdas/fn2/index.handler"
#   runtime = "nodejs22.x"

#   environment {
#     variables = {
#       ENVIRONMENT = var.environment
#     }
#   }
# }


# data "archive_file" "fn1_lambda_zip" {
#   type        = "zip"
#   source_dir  = "../dist"
#   output_path = "${path.module}/lambda-packages/fn1-lambda.zip"
# }

resource "aws_lambda_function" "fn1_lambda" {
  function_name = "fn1-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.authorizer_lambda_zip.key
  s3_object_version = aws_s3_object.authorizer_lambda_zip.version_id

  handler = "lambdas/fn1/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

# data "archive_file" "fn2_lambda_zip" {
#   type        = "zip"
#   source_dir  = "../dist"
#   output_path = "${path.module}/lambda-packages/fn2-lambda.zip"
# }

resource "aws_lambda_function" "fn2_lambda" {
  function_name = "fn2-lambda-${var.environment}"
  role          = aws_iam_role.lambda_exec_role.arn

  s3_bucket         = aws_s3_bucket.lambda_bucket.id
  s3_key            = aws_s3_object.authorizer_lambda_zip.key
  s3_object_version = aws_s3_object.authorizer_lambda_zip.version_id

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
  s3_key            = aws_s3_object.authorizer_lambda_zip.key
  s3_object_version = aws_s3_object.authorizer_lambda_zip.version_id

  handler = "lambdas/fn3/index.handler"
  runtime = "nodejs22.x"

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}
