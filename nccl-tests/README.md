# NCCL Tests Installation Script

This script automates the installation process of NVIDIA NCCL (NVIDIA Collective Communications Library) tests on Ubuntu systems. It handles all dependencies, compilation, and installation of the test binaries.

## Features

- Automated installation of CUDA repository keyring
- Installation of NCCL libraries and dependencies
- OpenMPI installation and configuration
- Compilation of NCCL tests from source
- Installation of test binaries to `/usr/bin` for system-wide access
- Automatic cleanup after installation

## Prerequisites

- Ubuntu 22.04 or compatible system
- sudo privileges
- Internet connection
- NVIDIA GPU with compatible drivers installed

## Quick Installation

Choose one of the following methods to install:

Using curl:
```bash
curl -sSL https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/nccl-tests/install_nccl_tests.sh | bash
```

Using wget:
```bash
wget -qO- https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/nccl-tests/install_nccl_tests.sh | bash
```

## Available Tests

After installation, the following test binaries will be available in `/usr/bin`:

- `all_reduce_perf`: Tests All-Reduce collective operation
- `all_gather_perf`: Tests All-Gather collective operation
- `broadcast_perf`: Tests Broadcast collective operation
- `reduce_perf`: Tests Reduce collective operation
- `reduce_scatter_perf`: Tests Reduce-Scatter collective operation
- `sendrecv_perf`: Tests Send/Receive operation

## Usage Example

Run a simple all-reduce test:
```bash
mpirun -n 4 all_reduce_perf -b 8 -e 256M -f 2 -g 1
```

Parameters:
- `-n 4`: Run with 4 processes
- `-b 8`: Start with 8 bytes
- `-e 256M`: End with 256 MB
- `-f 2`: Increase size by factor of 2
- `-g 1`: Number of GPUs per process

## Troubleshooting

If you encounter any issues:

1. Ensure you have sudo privileges
2. Verify NVIDIA drivers are properly installed
3. Check system compatibility with CUDA
4. Ensure all required ports are open for MPI communication

## License

This installation script is released under the same license as NVIDIA's NCCL-Tests.

## Contributing

Feel free to submit issues and enhancement requests on our GitHub repository.

## Acknowledgments

- NVIDIA for providing NCCL and NCCL-Tests
- The OpenMPI project
- All contributors to this installation script

## Support

For support, please open an issue in the GitHub repository.