# Typescript AWS Template

## Setup
1- configure aws locally: https://oneof.atlassian.net/wiki/spaces/OB/pages/457703425/AWS+Credentials+Configuration
2- npm install -D @types/aws-lambda esbuild

## Simple Run/Deploy Instructions through CLI

1- npm run build

2- aws lambda update-function-code --function-name <FUNCTION_NAME>  --zip-file "fileb://dist/index.zip"

## Create Lambda 

aws lambda create-function --function-name <FUNCTION_NAME> --runtime "nodejs16.x" --role arn:aws:iam::123456789012:role/lambda-ex --zip-file "fileb://dist/index.zip" --handler index.handler

## Update Lambda 

aws lambda update-function-code --function-name <FUNCTION_NAME>  --zip-file "fileb://dist/index.zip"


## AWS Docs Reference
https://docs.aws.amazon.com/lambda/latest/dg/typescript-package.html


## terrafom

Contains script to deploy the lambda, it's queue trigger, and the sns queues for publication of success and failure.
