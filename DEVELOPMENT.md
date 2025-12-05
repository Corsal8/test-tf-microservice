# Local Development Guide

This document explains how to set up and run the local development environment for this project.

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop)
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
- [Node.js](https://nodejs.org/en/) (v22 or higher)
- [npm](https://www.npmjs.com/)
- An AWS account and configured credentials (for SAM CLI to use)

## 1. Start the Local Environment

The local environment consists of a SQL Server and a DynamoDB container, managed by Docker Compose.

To start the databases, run:

```bash
docker-compose -f local-dev/docker-compose.yml up -d
```

This will start the containers in the background. The following services will be available:

- **SQL Server:** on `localhost:1433`
- **DynamoDB Local:** on `localhost:8000`

## 2. Install Dependencies

Install all the necessary Node.js packages by running:

```bash
npm install
```

This will also generate the Prisma client.

## 3. Run the Local API

AWS SAM CLI is used to run the Lambda functions and the API Gateway locally.

Before running the API, you need to build the Lambda functions:

```bash
sam build
```

Once the build is complete, you can start the local API:

```bash
sam local start-api --docker-network test-terraform-microservice_local-dev-net
```

**Note:** The `--docker-network` flag is crucial. It connects the SAM containers (running the Lambda functions) to the same Docker network as the databases, allowing them to communicate. The network name is based on the project directory. If you have issues, you can find the exact name by running `docker network ls`.

Your API will be available at `http://127.0.0.1:3000`.

## 4. Connecting to the Local Databases

### SQL Server

- **Host:** `localhost`
- **Port:** `1433`
- **User:** `sa`
- **Password:** `Password1234`
- **Database:** `master`

You can use any SQL client (like DBeaver, Azure Data Studio, etc.) to connect to this database.

### DynamoDB Local

- **Endpoint URL:** `http://localhost:8000`

You can use the AWS CLI to interact with the local DynamoDB. For example, to list the tables:

```bash
aws dynamodb list-tables --endpoint-url http://localhost:8000
```
