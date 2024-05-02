#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker before running this script."
    exit 1
fi

# Get Docker version
docker_version=$(docker --version | awk '{print $3}')

echo "Docker version: $docker_version"

# Prompt user to proceed
read -p "Do you want to proceed? (y/n): " choice

case "$choice" in
    y|Y )
        echo "Proceeding..."

        # Run the commands
        sudo yum update || { echo "Error: Failed to update yum"; exit 1; }
        curl -o docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-25.0.3.tgz || { echo "Error: Failed to download Docker."; exit 1; }
        tar xzvf docker.tar.gz || { echo "Error: Failed to extract Docker."; exit 1; }
        cd docker || { echo "Error: Failed to change directory to Docker."; exit 1; }
        sudo cp docker /usr/bin/ || { echo "Error: Failed to copy Docker to /usr/bin/."; exit 1; }

        # If all commands succeed, check and display the version of Docker again
        docker_version=$(docker --version | awk '{print $3}')
        echo "Installed Docker version: $docker_version"
        ;;
    n|N )
        echo "Exiting..."
        exit 0
        ;;
    * )
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac
