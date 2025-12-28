variable "aws_region" {
  description = "The AWS region to deploy the infrastructure to."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "The deployment environment (e.g., develop, staging, production)."
  type        = string
  default     = "develop"
}

