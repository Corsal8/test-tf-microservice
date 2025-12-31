console.log("Before everything");

import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { prisma } from "../../lib/prisma";

console.log("Handler initialization");

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

  const codeNumber = Math.floor(Math.random() * 1000);

  console.log("Creating code:", codeNumber);
  const code = await prisma.code.create({
    data: {
      name: `Fake code ${codeNumber}`,
      content: `Description of the fake code ${codeNumber}`,
    },
  });
  console.log("Created code:", code);
  const allCodes = await prisma.code.findMany({});
  console.log("All codes:", JSON.stringify(allCodes, null, 2));

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from DB",
      codes: allCodes,
    }),
  };
};
