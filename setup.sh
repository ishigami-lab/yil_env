#!/bin/bash
# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found. Please install Docker first."
    exit
fi

# Navigate to the directory containing the Dockerfile
cd "$(dirname "$0")"

# Build the image
docker build -t genesis-simulator ./docker

# Now, run the container and mount your scripts directory and meshes directory
docker run -it --rm \
  -v "$(pwd)/scripts:/workspace/scripts" \
  -v "$(pwd)/meshes:/workspace/meshes" \
  genesis-simulator