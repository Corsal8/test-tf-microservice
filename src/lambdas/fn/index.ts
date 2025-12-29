import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import axios from "axios";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

  const idx = Math.floor(Math.random() * 100);
  const todo = await axios.get(
    `https://jsonplaceholder.typicode.com/todos/${idx}`
  );
  console.log(`TODO ${idx}`, todo.data);

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from Fn",
      todo: todo.data,
    }),
  };
};
