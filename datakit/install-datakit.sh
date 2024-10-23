#!/bin/bash

# Check if token parameter is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <token>"
    exit 1
fi

# Store token from parameter
TOKEN=$1

# Set environment variables
export DK_HTTP_LISTEN="127.0.0.1"
export DK_DEF_INPUTS="cpu,disk,diskio,mem,swap,system,net,host_processes,hostobject,container,dk,logging,ebpf,prom"
export DK_DATAWAY="https://us1-openway.guance.com?token=${TOKEN}"

# Install DataKit
bash -c "$(curl -L https://static.guance.com/datakit/install.sh)"

# Create and configure ebpf.conf
cat << 'EOF' | sudo tee /usr/local/datakit/conf.d/host/ebpf.conf > /dev/null
[[inputs.ebpf]]
  daemon = true
  name = 'ebpf'
  cmd = "/usr/local/datakit/externals/datakit-ebpf"
  args = [
    "--datakit-apiserver", "127.0.0.1:9529",
  ]
  envs = []
  enabled_plugins = [
    "bpf-netlog",
  ]
  l7net_enabled = [
    "httpflow",
  ]
  pprof_host = "127.0.0.1"
  pprof_port = "6061"
  netlog_metric = true
  netlog_log = false
EOF

# Create prom directory and configure prom.conf
sudo mkdir -p /usr/local/datakit/conf.d/prom
cat << 'EOF' | sudo tee /usr/local/datakit/conf.d/prom/prom.conf > /dev/null
[[inputs.prom]]
  urls = ["http://127.0.0.1:9400/metrics"]
  ignore_req_err = false
  source = "dcgm"
  measurement_prefix = "gpu_"
  measurement_name = "dcgm"
  election = true
  [inputs.prom.tags_rename]
    overwrite_exist_tags = false
  [inputs.prom.as_logging]
    enable = false
    service = "service_name"
EOF

# Copy nvidia_smi configuration
cp -f /usr/local/datakit/conf.d/gpu_smi/nvidia_smi.conf.sample /usr/local/datakit/conf.d/gpu_smi/nvidia_smi.conf

# Restart DataKit service
sudo datakit service -R

echo "DataKit installation and configuration completed successfully!"