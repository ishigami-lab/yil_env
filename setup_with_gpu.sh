#!/bin/bash
# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found. Please install Docker first."
    exit
fi

# Install nvidia-docker2 if not already installed
if ! dpkg -l | grep -q nvidia-docker2; then
    echo "Installing nvidia-docker2..."
    # Add NVIDIA's GPG key and repository
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    sudo apt-get update
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker

    echo "nvidia-docker2 installed successfully!"
else
    echo "nvidia-docker2 is already installed."
fi

# Navigate to the directory containing the Dockerfile
cd "$(dirname "$0")"

# Build the image
docker build -t genesis-simulator ./docker

# Now, run the container and mount your scripts directory and meshes directory
docker run -it --rm --gpus all \
  -v "$(pwd)/scripts:/workspace/scripts" \
  -v "$(pwd)/meshes:/workspace/meshes" \
  genesis-simulator