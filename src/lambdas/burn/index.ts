import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { prisma } from "../../lib/prisma";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("EVENT", JSON.stringify(event));

  const result = (await prisma.$queryRaw`
    UPDATE TOP (1) Code
    SET 
      isUsed = 1 
    OUTPUT 
      inserted.id,
      inserted.name,
      inserted.content,
      inserted.isUsed
    WHERE id IN (
      SELECT TOP (1) id
      FROM Code WITH (UPDLOCK, READPAST)
      WHERE isUsed = 0
      ORDER BY id ASC
    );
  `) as { id: number; name: string }[];

  if (result.length === 0) {
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "No available codes to burn.",
        codes: [],
      }),
    };
  }

  return {
    statusCode: 200,
    body: JSON.stringify({
      message: "Hello from DB",
      codes: result[0],
    }),
  };
};
