#!/bin/bash

# Build docker image
echo "Building JDK Docker image..."
docker build -t eclipse-temurin-jdk .
if [ $? -eq 0 ]; then
    echo "Build successful, running the container..."
    # Run docker container
    docker run -it --rm -p 8081:8081 -p 5037:5037 -v ~/development/data-annotation-work:/root/repo/data-annotation-work eclipse-temurin-jdk
else
    echo "Docker build failed, not running the container."
fi
