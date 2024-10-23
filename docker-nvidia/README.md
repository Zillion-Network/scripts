# Docker and NVIDIA Container Toolkit Installation Script

This script automates the installation of Docker and NVIDIA Container Toolkit on Linux systems. It includes automatic region detection to use the appropriate Docker installation source based on your location.

## Features

- Automated Docker installation with region-based source selection
- NVIDIA Container Toolkit installation and configuration
- Automatic error handling and validation
- Root privilege checking
- Progress tracking with detailed status messages

## Quick Installation

For quick installation, you can run the following command:

```bash
curl -sSL https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/docker-nvidia/install-docker-nvidia.sh | bash
```

## Manual Installation

If you prefer to examine the script before running it, you can:

1. Download the script:
```bash
curl -O https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/docker-nvidia/install-docker-nvidia.sh
```

2. Make it executable:
```bash
chmod +x install-docker-nvidia.sh
```

3. Run the script:
```bash
sudo ./install-docker-nvidia.sh
```

## Prerequisites

- Linux-based operating system
- Root access or sudo privileges
- Working internet connection
- NVIDIA GPU and drivers installed (for NVIDIA Container Toolkit)

## What Does the Script Do?

The script performs the following operations:

1. Checks for root privileges
2. Detects server location for optimal Docker installation source
3. Installs Docker using the appropriate source
4. Installs NVIDIA Container Toolkit
5. Configures Docker to work with NVIDIA GPUs
6. Restarts the Docker daemon to apply changes

## Error Handling

The script includes comprehensive error handling and will:
- Exit on any error with informative messages
- Validate root access before proceeding
- Report the specific line number where any error occurs

## Troubleshooting

If you encounter any issues:

1. Ensure you have root privileges
2. Check your internet connection
3. Verify that NVIDIA drivers are properly installed
4. Check system logs for detailed error messages

## Support

If you encounter any issues or need assistance, please open an issue in the GitHub repository.

## License

This script is provided under the MIT License. See the LICENSE file for details.

## Security Note

Always review scripts before executing them with root privileges. While this script is designed to be safe, it's good practice to verify the contents of any script you download from the internet before running it.