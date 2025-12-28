variable "aws_region" {
  description = "The AWS region to deploy the infrastructure to."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "The deployment environment (e.g., develop, staging, production)."
  type        = string
}

variable "lambda_artifacts_bucket_name" {
  description = "The name of the S3 bucket where the Lambda artifacts are stored."
  type        = string
}

variable "authorizer_lambda_artifact_s3_key" {
  description = "The S3 key for the authorizer Lambda artifact."
  type        = string
}

variable "server_lambda_artifact_s3_key" {
  description = "The S3 key for the server Lambda artifact."
  type        = string
}

variable "authorizer_lambda_artifact_hash" {
  description = "The base64-encoded SHA256 hash of the authorizer Lambda artifact."
  type        = string
}

variable "server_lambda_artifact_hash" {
  description = "The base64-encoded SHA256 hash of the server Lambda artifact."
  type        = string
}
