#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/Pretid/galactica_helpers/main/utils/common.sh)

displayLogo

# Displaying script purpose
echo "This script sets up Prometheus to monitor a validator host."
echo "It prompts for input variables and then configures Prometheus accordingly."

# Prompt user for input
read -p "Enter the validator IP address: " VALIDATOR_IP
read -p "Enter Prometheus version (now it's 2.51.2): " VER
read -p "Enter the username (root by default): " USER
read -p "Enter the validator name (VALIDATOR_NAME): " VALIDATOR_NAME

# Download Prometheus and set up configuration
wget https://github.com/prometheus/prometheus/releases/download/v$VER/prometheus-$VER.linux-amd64.tar.gz
tar xvfz prometheus-$VER.linux-amd64.tar.gz
sudo rm -f prometheus-$VER.linux-amd64.tar.gz
mv prometheus-$VER.linux-amd64/ prometheus/
cd prometheus/

sudo ln -s $HOME/prometheus/prometheus /usr/local/bin/

# Configure Prometheus targets
sudo echo "
# Validator Host Hardware Metrics
  - job_name: \"$VALIDATOR_NAME hardware-metrics\"
    # validator ip and port
    static_configs:
      - targets: [\"$VALIDATOR_IP:9100\"]">> /root/prometheus/prometheus.yml

sudo echo "
# Validator Host Hardware Metrics
  - job_name: \"$VALIDATOR_NAME validator-metrics\"
    # validator ip and port
    static_configs:
      - targets: [\"$VALIDATOR_IP:26660\"]">> /root/prometheus/prometheus.yml

# Create Prometheus service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
After=network-online.target
[Service]
User=$USER
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=prometheus --config.file=$HOME/prometheus/prometheus.yml
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM
[Install]
WantedBy=multi-user.target
EOF

# Enable and start Prometheus service
sudo systemctl daemon-reload
sudo systemctl enable prometheus.service
sudo systemctl start prometheus.service
# Allow traffic on port 9090
sudo ufw allow 9090/tcp

# Display information message
echo "Check https://prometheus_ip:9090/graph"
