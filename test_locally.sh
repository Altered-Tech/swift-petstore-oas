#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Exit if any part of a pipeline fails

echo "Building Swift package archive..."
swift package archive --verbose --allow-network-connections docker

echo "Building SAM application..."
sam build

echo "Starting local API Gateway..."
sam local start-api --template template.yml --warm-containers EAGER --disable-authorizer 2>&1 | tee sam_logs.txt &

# Give some time for the API Gateway to start
sleep 15

echo "Running Schemathesis..."
schemathesis run ./Sources/openapi.yaml --base-url 'http://127.0.0.1:3000' --hypothesis-phases=explicit

echo "Stopping local API Gateway..."
pkill -f "sam local start-api"