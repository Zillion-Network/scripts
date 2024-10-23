#!/bin/bash

# Exit on any error
set -e

# Function to check if script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root"
        exit 1
    fi
}

# Function to handle errors
handle_error() {
    echo "An error occurred on line $1"
    exit 1
}

# Function to check if the server is located in China
is_in_china() {
    # Use curl to check country code from ipapi.co
    local country_code=$(curl -s https://ipapi.co/country)
    if [ "$country_code" = "CN" ]; then
        return 0  # In China
    else
        return 1  # Not in China
    fi
}

# Function to install Docker
install_docker() {
    if is_in_china; then
        echo "Detected China mainland network, using domestic installation source..."
        curl -fsSL https://install.1panel.live/docker-install | bash || {
            echo "Failed to install Docker using domestic source"
            exit 1
        }
    else
        echo "Using global Docker installation source..."
        curl -sSL https://get.docker.com/ | sh || {
            echo "Failed to install Docker"
            exit 1
        }
    fi
}

# Set up error handling
trap 'handle_error $LINENO' ERR

# Main installation function
main() {
    echo "Starting installation of Docker and NVIDIA Container Toolkit..."
    
    # Install Docker with region detection
    echo "Installing Docker..."
    install_docker
    
    # Add NVIDIA GPG key (with force overwrite)
    echo "Adding NVIDIA GPG key..."
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor --yes -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    
    # Add NVIDIA repository
    echo "Adding NVIDIA repository..."
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    
    # Enable experimental packages
    echo "Enabling experimental packages..."
    sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list
    
    # Update package list and install NVIDIA Container Toolkit
    echo "Installing NVIDIA Container Toolkit..."
    apt-get update
    apt-get install -y nvidia-container-toolkit
    
    # Configure Docker runtime
    echo "Configuring Docker runtime..."
    nvidia-ctk runtime configure --runtime=docker
    
    # Restart Docker daemon
    echo "Restarting Docker daemon..."
    systemctl restart docker
    
    echo "Installation completed successfully!"
}

# Check if running as root first
check_root

# Run main installation
main

exit 0