terraform {
  backend "s3" {
    bucket       = "corsal-terraform-states"
    key          = "test-tf-microservice/staging/terraform.tfstate"
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
  region = var.env_config.aws_region

  default_tags {
    tags = {
      Project     = "${var.env_config.project_name}"
      Environment = "${var.env_config.env_name}"
      ManagedBy   = "Terraform"
    }
  }
}
