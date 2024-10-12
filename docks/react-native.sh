#!/bin/bash

# Build docker image
echo "Building Docker image..."
docker build -t react-native-android-dev:latest ./react-native
if [ $? -eq 0 ]; then
    echo "Build successful, running the container..."
    # Run docker container
    docker run -it --rm -p 8081:8081 -p 5037:5037 -v ~/development/repo/react-native:/root/repo/react-native react-native-android-dev:latest
else
    echo "Docker build failed, not running the container."
fi
