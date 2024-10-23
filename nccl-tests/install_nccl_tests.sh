#!/bin/bash

# Exit on any error
set -e

echo "Starting NCCL Tests installation..."

# Install CUDA repository keyring
echo "Installing CUDA repository keyring..."
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
rm cuda-keyring_1.1-1_all.deb

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install NCCL dependencies
echo "Installing NCCL libraries..."
sudo apt install libnccl2 libnccl-dev -y

# Verify NCCL installation
echo "Verifying NCCL installation..."
dpkg -l | grep nccl

# Install OpenMPI
echo "Installing OpenMPI..."
sudo apt update
sudo apt install openmpi-bin openmpi-doc libopenmpi-dev -y

# Verify OpenMPI installation
echo "Verifying OpenMPI installation..."
mpirun --version

# Clone and build NCCL tests
echo "Cloning NCCL tests repository..."
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests

echo "Building NCCL tests..."
make MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi

# Install built binaries to /usr/bin
echo "Installing NCCL test binaries to /usr/bin..."
sudo cp build/* /usr/bin/

# Verify installation
echo "Verifying binary installation..."
for binary in all_reduce_perf all_gather_perf broadcast_perf reduce_perf reduce_scatter_perf sendrecv_perf; do
    if [ -f "/usr/bin/${binary}" ]; then
        echo "${binary} installed successfully"
        sudo chmod +x "/usr/bin/${binary}"
    else
        echo "Warning: ${binary} not found"
    fi
done

# Cleanup
echo "Cleaning up..."
cd ..
rm -rf nccl-tests

echo "NCCL Tests installation completed successfully!"
echo "The test binaries have been installed to /usr/bin and are ready to use."