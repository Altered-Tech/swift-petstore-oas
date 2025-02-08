# Petstore OpenAPI/SAM

This application illustrates how to utilize swift-openapi-generator with swift-openapi lambda to create multiple functions definitions in the SAM Template. It is available to deploy a Server-Side Swift workload on AWS using the [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/) toolkit. It deploys the API using Amazon API Gateway. 

## Architecture

![Architecture](images/architecture.png)

- OpenAPI Spec to define our API
- Amazon API Gateway receives API requests
- API Gateway invokes Lambda functions to process POST, PUT, GET, and DELETE events
- Lambda functions written in Swift use the [AWS SDK for Swift](https://aws.amazon.com/sdk-for-swift/) and the [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime) to retrieve and save items.
- Schemathesis to contract validate that our server behaves as we believe it should against our OpenAPI spec in spec-driven development.

## Prerequisites

To build this sample application, you need:

- [AWS Account](https://console.aws.amazon.com/)
- [AWS Command Line Interface (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) - install the CLI and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) it with credentials to your AWS account
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) - a command-line tool used to create serverless workloads on AWS
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) - to compile your Swift code for Linux deployment to AWS Lambda
- [Swift](https://www.swift.org/getting-started/) version 6.0

## Build the application

The **swift package archive** command compiles your Swift code for deployment to Lambda.

```
swift package archive --allow-network-connections docker
```

The **sam build** command packages your Swift Lambda functions for deployment to AWS.

```bash
sam build
```

### Deploy the application to AWS

Deploying your SAM project creates the Lambda functions, API Gateway, and DynamoDB database in your AWS account.

```bash
sam deploy --guided
```

Accept the default response to every prompt, except the following warnings:

```bash
GetPetById      has no authentication. Is this okay? [y/N]: y
GetPetsByStatus has no authentication. Is this okay? [y/N]: y
GetPetsByTags   has no authentication. Is this okay? [y/N]: y
UpdatePet       has no authentication. Is this okay? [y/N]: y
AddPet          has no authentication. Is this okay? [y/N]: y
```

The project creates a publicly accessible API endpoint. These are warnings to inform you the API does not have authorization. If you are interested in adding authorization to the API, please refer to the [SAM Documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-httpapi.html).

### Use the API

At the end of the deployment, SAM displays the endpoint of your API Gateway:

```bash
Outputs
----------------------------------------------------------------------------------------
Key                 SwiftAPIEndpoint
Description         API Gateway endpoint URL for your application
Value               https://[your-api-id].execute-api.[your-aws-region].amazonaws.com
----------------------------------------------------------------------------------------
```

Use cURL or a tool such as [Postman](https://www.postman.com/) to interact with your API. Replace **[your-api-endpoint]** with the SwiftAPIEndpoint value from the deployment output.

**Retrieve all Pets by Tags**

_Replace {Tag} with the tag of the pets you want to retrieve_ 

```bash
curl -X GET https://[your-api-endpoint]/pet/findByTag\?tag\={Tag}
```

**Retrieve all Pets by Status**

_Replace {Status} with the status of the pets you want to retrieve (sold, available, pending, none)_ 

```bash
curl -X GET https://[your-api-endpoint]/pet/findByStatus\?status\={Status}
```

**Retrieve a specific Pet**

_Replace {Pet ID} with the id of the pet you want to retrieve_

```bash
curl -X GET https://[your-api-endpoint]/pet/{Pet ID}
```

**Update a specific Pet**

_Replace json of the pet with the id of the pet you want to update_

```bash
curl -X PUT https://[your-api-endpoint]/pet '{"id": 1, "name": "bubbles","status": "sold","photoUrls": ["example.com"]}' --header "Content-Type: application/json"
```

**Add a Pet**

_Replace json with pet object to be added_

```bash
curl -x POST https://[your-api-endpoint]/pet '{"name": "bubbles","status": "sold","photoUrls": ["example.com"]}' --header "Content-Type: application/json"
```
### Cleanup

When finished with your application, use SAM to delete it from your AWS account. Answer **Yes (y)** to all prompts. This will delete all of the application resources created in your AWS account.

```bash
sam delete
```

## Test the API Locally

SAM also allows you to execute your Lambda functions locally on your development computer. Follow these instructions to execute each Lambda function. Further capabilities can be explored in the [SAM Documentation](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-using-invoke.html).

**Create Server**

```
DOCKER_HOST=unix://$HOME/.docker/run/docker.sock sam local start-api --template template.yml --disable-authorizer
```

**Schemathesis for Contract Validation**

```
schemathesis run --checks all --generation-allow-x00=false \
./Sources/openapi.yaml --base-url http://127.0.0.1:3000/ \
--hypothesis-seed=113557048121377334166457906999960982618
```

**Retrieve all Pets by Tags**

_Replace {Tag} with the tag of the pets you want to retrieve_ 

```bash
curl -X GET http://127.0.0.1:3000/pet/findByTag\?tag\={Tag}
```

**Retrieve all Pets by Status**

_Replace {Status} with the status of the pets you want to retrieve (sold, available, pending, none)_ 

```bash
curl -X GET http://127.0.0.1:3000/pet/findByStatus\?status\={Status}
```

**Retrieve a specific Pet**

_Replace {Pet ID} with the id of the pet you want to retrieve_

```bash
curl -X GET http://127.0.0.1:3000/pet/{Pet ID}
```

**Update a specific Pet**

_Replace json of the pet with the id of the pet you want to update_

```bash
curl -X PUT http://127.0.0.1:3000/pet '{"id": 1, "name": "bubbles","status": "sold","photoUrls": ["example.com"]}' --header "Content-Type: application/json"
```

**Add a Pet**

_Replace json with pet object to be added_

```bash
curl -x POST http://127.0.0.1:3000/pet '{"name": "bubbles","status": "sold","photoUrls": ["example.com"]}' --header "Content-Type: application/json"
```
