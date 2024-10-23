#!/bin/bash

# Exit on any error
set -e

echo "Starting NCCL Tests installation..."

# Remove existing CUDA installation
echo "Removing existing CUDA installation..."
sudo apt-get --purge remove -y "cuda*" "nvidia-cuda*"
sudo apt-get --purge remove -y "*cublas*" "cuda*"
sudo apt-get --purge remove -y "*nvidia*"
sudo apt-get autoremove -y
sudo apt-get autoclean -y

# Clean up CUDA paths
sudo rm -rf /usr/local/cuda*
sudo rm -rf /usr/lib/cuda*
sudo rm -rf /usr/lib/x86_64-linux-gnu/cuda*

# Install basic build tools
echo "Installing build essentials..."
sudo apt update
sudo apt install gcc make g++ wget -y

# Download and install CUDA
echo "Downloading and installing CUDA..."
wget https://developer.download.nvidia.com/compute/cuda/12.5.1/local_installers/cuda_12.5.1_555.42.06_linux.run
sudo sh cuda_12.5.1_555.42.06_linux.run --silent --driver --toolkit --samples --override-driver-check

# Clean up CUDA installer
rm cuda_12.5.1_555.42.06_linux.run

# Hold kernel packages to prevent updates
echo "Holding kernel packages to prevent automatic updates..."
for package in $(dpkg --get-selections | grep -E "linux-image|linux-headers|linux-modules" | awk '{print $1}'); do 
    echo "Holding package: $package"
    sudo apt-mark hold $package
done

# Verify held packages
echo "Verifying held packages:"
apt-mark showhold

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

# Add CUDA to PATH
echo "Configuring CUDA environment..."
cat > /etc/profile.d/cuda.sh << 'EOF'
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF

source /etc/profile.d/cuda.sh

# Verify CUDA installation
echo "Verifying CUDA installation..."
nvidia-smi
nvcc --version

# Clone and build NCCL tests
echo "Cloning NCCL tests repository..."
git clone https://github.com/NVIDIA/nccl-tests.git
cd nccl-tests

echo "Building NCCL tests..."
make MPI=1 MPI_HOME=/usr/lib/x86_64-linux-gnu/openmpi CUDA_HOME=/usr/local/cuda

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

# Print system information
echo "System information:"
echo "==================="
echo "NVIDIA Driver Info:"
nvidia-smi
echo "==================="
echo "CUDA Version:"
nvcc --version
echo "==================="
echo "Held Kernel Packages:"
apt-mark showhold
echo "==================="
echo "Installed CUDA Packages:"
dpkg -l | grep cuda

echo "NCCL Tests installation completed successfully!"
echo "The test binaries have been installed to /usr/bin and are ready to use."
echo "Kernel packages have been held to prevent updates that might break CUDA compatibility."
echo "Please reboot your system to ensure all changes take effect."