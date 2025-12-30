import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

const environment = process.env.ENVIRONMENT || "develop";

const client = new DynamoDBClient({
  region: process.env.AWS_REGION,
  // DYNAMODB_ENDPOINT only on local environment. In live servers, the SDK uses the default endpoint.
  endpoint: process.env.DYNAMODB_ENDPOINT,
});
const docClient = DynamoDBDocumentClient.from(client);

const TABLE_NAME = process.env.DYNAMODB_TABLE_NAME;

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT: ", JSON.stringify(event));
  console.log("ENVIRONMENT: ", environment);

  // Get the ID from the path parameters
  const id = event.pathParameters?.id || "test";

  if (!id) {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Error: Missing 'id' in path parameters.",
      }),
    };
  }

  // Prepare the command to get the item from DynamoDB
  const command = new GetCommand({
    TableName: TABLE_NAME,
    Key: {
      id: id,
    },
  });

  try {
    const response = await docClient.send(command);

    if (response.Item) {
      console.log("SUCCESS: Item found", response.Item);
      return {
        statusCode: 200,
        body: JSON.stringify(response.Item),
      };
    } else {
      console.log("NOT FOUND: Item not found in table");
      return {
        statusCode: 404,
        body: JSON.stringify({ message: `Item with id '${id}' not found.` }),
      };
    }
  } catch (error) {
    console.error("DYNAMODB ERROR", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal Server Error: Could not query DynamoDB.",
        error: (error as Error).message,
      }),
    };
  }
};
