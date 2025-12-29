
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.project_name}-${var.environment}-lambda-code"
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

resource "aws_s3_object" "lambda_package_zip" {
  bucket      = aws_s3_bucket.lambda_bucket.id
  key         = "lambda_package.zip"
  source      = data.archive_file.lambda_package_zip.output_path
  source_hash = data.archive_file.lambda_package_zip.output_base64sha256
}
