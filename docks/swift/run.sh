#!/bin/bash

# Define your Docker image tag
IMAGE_TAG="swift-dev-environment"

echo "Building Swift Docker image..."
docker build -t $IMAGE_TAG .

# Check if the docker build command was successful
if [ $? -eq 0 ]; then
    echo "Build successful, running the container..."
    # Ensure the local directory exists before running the container
    if [ -d "$HOME/development/data-annotation-work" ]; then
        docker run -it --rm -p 8081:8081 -p 5037:5037 -v $HOME/development/data-annotation-work:/root/repo/data-annotation-work $IMAGE_TAG
    else
        echo "Local directory does not exist, not running the container."
    fi
else
    echo "Docker build failed, not running the container."
fi
