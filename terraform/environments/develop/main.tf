terraform {
  backend "s3" {
    bucket       = "corsal-terraform-states"
    key          = "test-tf-microservice/develop/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "${var.project_name}"
      Environment = "${var.environment}"
      ManagedBy   = "Terraform"
    }
  }
}
