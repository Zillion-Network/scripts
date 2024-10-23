# DataKit Installation Guide

Install DataKit online with one click. Choose your preferred installation method below.

## Quick Installation

### Using curl
```bash
# using command line parameter
curl -sSL https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/datakit/install-datakit.sh | bash -s tkn_fdd7abc280e74578926359a801eb9123
```

### Using wget
```bash
# using command line parameter
wget -qO- https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/datakit/install-datakit.sh | bash -s tkn_fdd7abc280e74578926359a801eb9123
```

> **Note**: Replace `tkn_fdd7abc280e74578926359a801eb9123` with your actual token.

## Features
- One-click installation
- Automatic configuration
- GPU metrics collection support
- Built-in EBPF monitoring

## Requirements
- Linux operating system
- Root or sudo privileges
- Internet connection
- Valid DataKit token

## Post-Installation
After successful installation, DataKit service will:
1. Start automatically
2. Begin collecting system metrics
3. Monitor GPU if available
4. Enable EBPF monitoring

For more information, please visit our documentation.