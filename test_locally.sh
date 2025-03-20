#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -o pipefail  # Exit if any part of a pipeline fails

trap 'echo "Stopping local API Gateway..."; pkill -f "sam local start-api"' EXIT

echo "Checking if Docker is running..."
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "Building Swift package archive..."
swift package archive --verbose --allow-network-connections docker

echo "Building SAM application..."
sam build

echo "Starting local API Gateway..."
sam local start-api --template template.yml --warm-containers EAGER --disable-authorizer 2>&1 | tee sam_logs.txt &

# Give some time for the API Gateway to start
sleep 120

echo "Running Schemathesis Explicit Example test..."
schemathesis run ./Sources/openapi.yaml --base-url 'http://127.0.0.1:3000' \
--hypothesis-phases=explicit \
--generation-allow-x00=false \
--checks=all

echo "Running Schemathesis Set Seed test..."
schemathesis run ./Sources/openapi.yaml --base-url 'http://127.0.0.1:3000' \
--hypothesis-seed=47789167578022855610497879068613925682 \
--generation-allow-x00=false \
--data-generation-method=positive \
--checks=all

echo "Running Schemathesis Random test..."
schemathesis run ./Sources/openapi.yaml --base-url 'http://127.0.0.1:3000' \
--data-generation-method=all \
--checks=all