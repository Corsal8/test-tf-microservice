import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import axios from "axios";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

  const todo = await axios.get("https://jsonplaceholder.typicode.com/todos/2");
  console.log("TODO", todo.data);

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from Server!!",
      todo: todo.data,
    }),
  };
};
