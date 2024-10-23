#!/bin/bash

# Exit on any error
set -e

echo "### Installing NVIDIA DCGM and DCGM-exporter ###"

# Required packages
sudo apt-get update
sudo apt-get install -y curl wget rsyslog

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# GitHub repository information
REPO_RAW_URL="https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/dcgm-exporter"

# Download required files
echo "Downloading required files..."
FILES=(
    "dcgm-exporter"
    "default-counters.csv"
    "dcgm-custom-metrics.csv"
    "dcp-metrics-included.csv"
)

for file in "${FILES[@]}"; do
    echo "Downloading $file..."
    wget -q "$REPO_RAW_URL/$file" -O "$file"
    if [ $? -ne 0 ]; then
        echo "Error downloading $file"
        exit 1
    fi
done

# Check if datacenter-gpu-manager is already installed
if ! dpkg -l | grep -q datacenter-gpu-manager; then
    echo "Installing NVIDIA DCGM..."
    
    # Add NVIDIA repository key
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-archive-keyring.gpg | sudo apt-key add -
    
    # Add NVIDIA repository
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" | \
        sudo tee /etc/apt/sources.list.d/cuda-compute-repo.list
    
    # Update package lists
    sudo apt-get update
    
    # Install DCGM
    sudo apt-get install -y datacenter-gpu-manager
    
    # Enable and start DCGM service
    sudo systemctl daemon-reload
    sudo systemctl enable nvidia-dcgm.service
    sudo systemctl start nvidia-dcgm.service
else
    echo "NVIDIA DCGM is already installed"
fi

echo "Setting up DCGM-exporter..."

# Create required directories
sudo mkdir -p /etc/dcgm-exporter

# Copy and set permissions for dcgm-exporter binary
sudo cp dcgm-exporter /usr/bin/
sudo chmod 755 /usr/bin/dcgm-exporter

# Copy configuration files
for file in "default-counters.csv" "dcgm-custom-metrics.csv" "dcp-metrics-included.csv"; do
    sudo cp "$file" "/etc/dcgm-exporter/$file"
done

# Create systemd service file
cat << EOF | sudo tee /etc/systemd/system/dcgm_exporter.service
[Unit]
Description=DCGM Exporter
After=network.target nvidia-dcgm.service

[Service]
ExecStart=/usr/bin/dcgm-exporter --address 127.0.0.1:9400
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start DCGM-exporter service
sudo systemctl daemon-reload
sudo systemctl enable dcgm_exporter.service
sudo systemctl start dcgm_exporter.service

# Clean up
cd -
rm -rf "$TEMP_DIR"

echo "Installation completed successfully!"
echo "You can check the status of services using:"
echo "systemctl status nvidia-dcgm.service"
echo "systemctl status dcgm_exporter.service"