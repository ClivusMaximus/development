# Use the Eclipse Temurin JDK 17 image
FROM eclipse-temurin:17-jdk

# Install Maven and Gradle
RUN apt-get update && apt-get install -y \
    maven \
    gradle

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Run the application (example command)
CMD ["bash"]
