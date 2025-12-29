import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import axios from "axios";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

  const id = event.pathParameters?.id;
  const todo = await axios.get(
    `https://jsonplaceholder.typicode.com/todos/${id}`
  );
  console.log(`TODO ${id}`, todo.data);

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from FnId",
      todo: todo.data,
    }),
  };
};
