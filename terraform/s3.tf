
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "test-terraform-microservice-lambda-code-${var.environment}"

  tags = {
    Name        = "Lambda Code Storage"
    Environment = "${var.environment}"
  }
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket_ownership" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lambda_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "authorizer_lambda_zip" {
  bucket      = aws_s3_bucket.lambda_bucket.id
  key         = "authorizer-lambda.zip"
  source      = data.archive_file.authorizer_lambda_zip.output_path
  source_hash = data.archive_file.authorizer_lambda_zip.output_base64sha256
}

# resource "aws_s3_object" "server_lambda_zip" {
#   bucket       = aws_s3_bucket.lambda_bucket.id
#   key          = "server-lambda.zip"
#   source       = data.archive_file.server_lambda_zip.output_path
#   source_hash  = data.archive_file.server_lambda_zip.output_base64sha256
# }

# resource "aws_s3_object" "fn1_lambda_zip" {
#   bucket       = aws_s3_bucket.lambda_bucket.id
#   key          = "fn1-lambda.zip"
#   source       = data.archive_file.fn1_lambda_zip.output_path
#   source_hash  = data.archive_file.fn1_lambda_zip.output_base64sha256
# }

# resource "aws_s3_object" "fn2_lambda_zip" {
#   bucket       = aws_s3_bucket.lambda_bucket.id
#   key          = "fn2-lambda.zip"
#   source       = data.archive_file.fn2_lambda_zip.output_path
#   source_hash  = data.archive_file.fn2_lambda_zip.output_base64sha256
# }
