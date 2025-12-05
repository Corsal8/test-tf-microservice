# Project Scaffolding Plan

This document outlines the step-by-step plan to scaffold the Terraform-based microservice, using AWS SAM for local development and building, as per our discussion.

### 1. Core Project Structure
- Create the primary directory layout:
  - `src/`: For all Lambda source code.
  - `terraform/`: For all Terraform IaC files.
  - `.github/workflows/`: For the CI/CD pipeline definition.
  - `local-dev/`: For Docker Compose and local development assets.

### 2. Local Development Environment
- Create a `local-dev/docker-compose.yml` file to define the local environment.
- Add a **Microsoft SQL Server** service for the "Codes DB".
- Add an **Amazon DynamoDB Local** service for the "Config DB".
- Add a one-off script/service to create the necessary table in DynamoDB Local upon startup.

### 3. TypeScript Lambda & Prisma Setup
- Initialize a single root `package.json` for managing all Node.js dependencies.
- Create a root `tsconfig.json` for TypeScript compilation.
- Install necessary dependencies (`typescript`, `esbuild`, `prisma`, `@prisma/client`, `@types/aws-lambda`).
- Create placeholder source files for the `authorizer` and `server` lambdas inside `src/`.
- Initialize Prisma and create a `prisma/schema.prisma` file configured for SQL Server.

### 4. SAM Configuration for Local Testing
- Create a `template.yaml` file in the root directory.
- Define the two Lambda functions (`AuthorizerFunction`, `ServerFunction`) pointing to their source code in `src/`.
- Configure the `Metadata` section in the `template.yaml` to use `esbuild` for building the TypeScript code.
- Define a basic `Api` event source for the `ServerFunction`, configured to use the `AuthorizerFunction` as its authorizer.

### 5. Terraform Infrastructure as Code
- Inside the `terraform/` directory, create modular files:
  - `main.tf`: To define the AWS provider and required versions.
  - `variables.tf`: For input variables (e.g., region, S3 bucket for artifacts).
  - `iam.tf`: For the IAM execution roles needed by the Lambda functions.
  - `lambda.tf`: To define the `aws_lambda_function` resources. These will be configured to fetch their code from an S3 bucket.
  - `api_gateway.tf`: To define the API Gateway, its endpoints, methods, and authorizer integration.
  - `s3.tf`: To define the S3 bucket that will store the lambda artifacts.

### 6. CI/CD Workflow
- Create a `.github/workflows/deploy.yml` file.
- The workflow will have two main jobs:
  1. **Build & Package:**
     - Checks out the code.
     - Runs `npm install` and `npx prisma generate`.
     - Runs `sam build` to create the deployable Lambda artifacts.
     - Zips the artifacts and uploads them to the S3 deployment bucket.
  2. **Deploy:**
     - Depends on the "Build & Package" job.
     - Sets up Terraform.
     - Runs `terraform apply`, passing the identifier of the new artifact in S3 so the Lambda function resources are updated.

### 7. Documentation
- Create a `DEVELOPMENT.md` file explaining the local development workflow:
  - How to start the environment with `docker-compose`.
  - How to run the local API with `sam local start-api`.
  - How to connect to the local databases.
