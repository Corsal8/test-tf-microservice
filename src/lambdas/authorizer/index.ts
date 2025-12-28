import {
  APIGatewayAuthorizerResult,
  APIGatewayRequestAuthorizerEvent,
  StatementEffect,
} from "aws-lambda";

export const handler = async (
  event: APIGatewayRequestAuthorizerEvent
): Promise<APIGatewayAuthorizerResult> => {
  console.log("EVENT", JSON.stringify(event));

  const effect: StatementEffect = "Allow"; // or 'Deny'

  const policy = {
    principalId: "user",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: effect,
          Resource: event.methodArn,
        },
      ],
    },
  };

  return policy;
};
