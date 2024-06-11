#!/bin/bash

# Check if Prometheus is already installed
if [ -d "/opt/prometheus" ]; then
  echo "Prometheus is already installed. Exiting."
  exit 0
fi

# Update the package list
sudo apt update

# Install necessary dependencies
sudo apt install -y wget

# Download the Prometheus tarball
wget https://github.com/prometheus/prometheus/releases/download/v2.29.2/prometheus-2.29.2.linux-amd64.tar.gz

# Extract the tarball
tar xvfz prometheus-2.29.2.linux-amd64.tar.gz

# Move the extracted directory to /opt
sudo mv prometheus-2.29.2.linux-amd64 /opt/prometheus

# Create a configuration file (prometheus.yml)
cat <<EOF > /opt/prometheus/prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
EOF

# Start Prometheus
/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml
