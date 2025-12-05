#!/bin/sh

# Wait for DynamoDB Local to be ready
# (This is a simple wait loop; in a real-world scenario, you might use a more robust tool like aws-cli-waiters)
until aws dynamodb list-tables --endpoint-url http://dynamodb-local:8000 --region us-east-1 > /dev/null 2>&1; do
  echo "Waiting for DynamoDB to be ready..."
  sleep 2
done

echo "DynamoDB is ready. Creating table..."

# Create the DynamoDB table
aws dynamodb create-table \
    --table-name ConfigTable \
    --attribute-definitions AttributeName=key,AttributeType=S \
    --key-schema AttributeName=key,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://dynamodb-local:8000 \
    --region us-east-1

echo "Table 'ConfigTable' created."
