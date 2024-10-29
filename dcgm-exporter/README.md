# NVIDIA DCGM Exporter Installation Guide

This guide provides instructions for installing NVIDIA DCGM (Data Center GPU Manager) and DCGM-exporter on Ubuntu systems.

## Quick Installation

### Using curl

You can quickly install DCGM-exporter using curl with the following command:

```bash
curl -sSL https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/dcgm-exporter/install-dcgm-exporter.sh | sudo bash
```

### Using wget

Alternatively, you can use wget to download and execute the installation script:

```bash
wget -qO- https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/dcgm-exporter/install-dcgm-exporter.sh | sudo bash
```

## What the Installation Script Does

The installation script performs the following actions:

1. Installs required packages (curl, wget, rsyslog)
2. Downloads necessary configuration files:
   - dcgm-exporter binary
   - default-counters.csv
   - dcgm-custom-metrics.csv
   - dcp-metrics-included.csv
3. Installs NVIDIA DCGM if not already installed:
   - Adds NVIDIA repository and keys
   - Installs datacenter-gpu-manager package
   - Enables and starts nvidia-dcgm service
4. Sets up DCGM-exporter:
   - Creates required directories
   - Copies configuration files
   - Creates and enables systemd service

## Verification

After installation, you can verify the services are running properly:

```bash
# Check DCGM service status
systemctl status nvidia-dcgm.service

# Check DCGM-exporter service status
systemctl status dcgm_exporter.service
```

The DCGM-exporter will be listening on `127.0.0.1:9400` by default.

## Security Considerations

- The installation script requires root privileges (sudo access)
- The script downloads files from GitHub; ensure you trust the source
- Consider checking the script's signature or hash if provided
- The exporter is configured to listen only on localhost (127.0.0.1) by default

## Troubleshooting

If you encounter any issues:

1. Check system requirements:
   - Ubuntu 22.04 or compatible system
   - NVIDIA GPU with appropriate drivers installed
   - Sufficient disk space
   
2. Verify log files:
```bash
# Check DCGM logs
journalctl -u nvidia-dcgm.service

# Check DCGM-exporter logs
journalctl -u dcgm_exporter.service
```
