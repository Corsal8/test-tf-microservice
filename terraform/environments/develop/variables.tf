variable "aws_region" {
  description = "The AWS region to deploy the infrastructure to."
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "A unique name for the project."
  type        = string
  default     = "test-tf-microservice"
}

variable "environment" {
  description = "The deployment environment (e.g., develop, staging, production)."
  type        = string
  default     = "develop"
}

variable "log_retention_days" {
  description = "The number of days to retain cloudwatch logs."
  type        = number
  default     = 30
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name."
  type        = string
  default     = "Environments"
}


variable "db_connection_string" {
  description = "DB Connection String."
  type        = string
  default     = "fakeConnectionString"
}

