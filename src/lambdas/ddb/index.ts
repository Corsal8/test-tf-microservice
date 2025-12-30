import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, GetCommand } from "@aws-sdk/lib-dynamodb";

// Create a DynamoDB client configured for local Docker
const client = new DynamoDBClient({
  region: "localhost", // Can be any value for local, but needed
  endpoint: "http://dynamodb-local:8000",
  credentials: {
    accessKeyId: "dummy", // Dummy credentials for local DynamoDB
    secretAccessKey: "dummy", // Dummy credentials for local DynamoDB
  },
});
const docClient = DynamoDBDocumentClient.from(client);

const TABLE_NAME = "Environments";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

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
