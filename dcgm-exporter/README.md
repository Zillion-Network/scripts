# DCGM Exporter Installation Guide

NVIDIA DCGM Exporter collects and exports GPU metrics for monitoring. This guide explains how to install it on Ubuntu 22.04.

## System Requirements

- **Operating System**: Ubuntu 22.04 LTS
- **Hardware**: NVIDIA GPU(s)
- **Prerequisites**:
  - NVIDIA Driver installed
  - Internet connection
  - Root or sudo privileges

## Quick Installation

Choose one of the following methods to install:

### Using curl
```bash
curl -sSL https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/dcgm-exporter/install-dcgm-exporter.sh | bash
```

### Using wget
```bash
wget -qO- https://raw.githubusercontent.com/Zillion-Network/scripts/refs/heads/main/dcgm-exporter/install-dcgm-exporter.sh | bash
```

## What Gets Installed

The installation script will automatically:
1. Install NVIDIA DCGM (Data Center GPU Manager)
2. Install DCGM Exporter
3. Configure system service
4. Set up Prometheus metrics endpoint

## Default Configuration

- **Service Name**: `dcgm-exporter.service`
- **Metrics Port**: 9400
- **Metrics Endpoint**: `http://127.0.0.1:9400/metrics`
- **Systemd Integration**: Yes
- **Auto-start on Boot**: Enabled

## Verification Steps

After installation, verify the setup:

1. Check service status:
```bash
systemctl status dcgm-exporter
```

2. Test metrics endpoint:
```bash
curl 127.0.0.1:9400/metrics
```

## Monitoring Integration

DCGM Exporter metrics can be collected by:
- Prometheus
- Grafana
- DataKit
- Other Prometheus-compatible monitoring systems

## Troubleshooting

If the service fails to start:
1. Check NVIDIA driver installation: `nvidia-smi`
2. Verify DCGM status: `systemctl status nvidia-dcgm`
3. Check logs: `journalctl -u dcgm-exporter`

## Support

For issues or questions:
- Check system logs
- Visit NVIDIA DCGM documentation
- Report issues on GitHub
