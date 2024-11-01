import { Context, APIGatewayProxyResult, APIGatewayEvent, SQSEvent } from 'aws-lambda';

export interface Request {}
export interface Response {}

export const handler = async (event: SQSEvent, context: Context): Promise<APIGatewayProxyResult> => {
    console.log(event)
    const request : Request = JSON.parse(event.Records[0].body);
    
    console.log("Request is : ", request);

    const response : Response = {};

    return {
        statusCode: 200,
        body: JSON.stringify({
            message: response,
        }),
    };
};